module State exposing (..)

import AnimationFrame
import Player.State
import Geometry       exposing (Direction, Attitude, Position, Vector)
import Player.Types   exposing (Player)
import Time           exposing (..)
import Keyboard
import Window         exposing (Size)
import Types          exposing (..)
import Http           exposing (Error)
import Task           exposing (Task)
import Core           exposing (iff)
-- import Exts.Tuple     exposing (both)

initialState : ( Model, Cmd Msg )
initialState =
    ( { wsize = { width = 800, height = 800 }
      , keys = { left  = False
               , right = False
               , up    = False
               , down  = False
               , enter = False
               }
      , player = Player.State.initialState
      , zombie = { position = { x = 100, y = 100 }
                 , attitude =
                       { direction = 0.0
                       , velocity = 0.0
                       }
                 }
      }
    , Cmd.batch
        [ Window.size |> windowSize ]
    )

{-
keyMap : Int -> Maybe Player.Types.Msg
keyMap keyCode =
    case (Char.fromCode keyCode) of
        'a' -> Just (Player.Types.Move Left)
        'd' -> Just (Player.Types.Move Right)
        's' -> Just (Player.Types.Move Down)
        'w' -> Just (Player.Types.Move Right)
        ' ' -> Just (Player.Types.Attack)
        _   -> Nothing
-}

{- SPEC
pressing_the_a_key_makes_the_player_turn_left
pressing_the_d_key_makes_the_player_turn_right
pressing_the_w_key_makes_the_player_move_forward
pressing_the_s_key_makes_the_player_move_backward
pressing_the_enter_key_makes_the_player_attack
pressing any other key does nothing
-}               
keyChange : Bool -> Keyboard.KeyCode -> Msg
keyChange on key =
    let
        a = 65
        d = 68
        w = 87
        s = 83
        -- space = 32
        enter = 13
                
        updateKeysFn : Keys -> Keys
        updateKeysFn =
            if key == a then
                \k -> { k | left  = on }
            else if key == d then
                \k -> { k | right = on }
            else if key == w then
                \k -> { k | up    = on }
            else if key == s then
                \k -> { k | down  = on }
            else if key == enter then
                \k -> { k | enter = on }
            else
                Basics.identity
    in
        KeyChange updateKeysFn

type Enum
    = Positive
    | Zero
    | Negative

prev : Enum -> Enum
prev enum =
    case enum of
        Positive -> Zero
        Zero     -> Negative
        Negative -> Negative

succ : Enum -> Enum
succ enum =
    case enum of
        Positive -> Positive
        Zero     -> Positive
        Negative -> Zero

fromDirection : Int -> (Attitude, Vector)
fromDirection direction =
    case direction of
        180  -> ( { direction = (degrees 180.0)
                  , velocity  = 1.0
                  }
                , { x = 0, y = 1 })
        (-180) -> ( { direction = (degrees -180.0)
                 , velocity  = 1.0
                 }
               , { x = 0, y = 1 })
        225  -> ( { direction = (degrees 225.0)
                  , velocity  = 1.0
                  }
                , { x = -1, y = 1 })
        (-135) -> ( { direction = (degrees -135.0)
                  , velocity  = 1.0
                  }
                , { x = -1, y = 1 })
        270 -> ( { direction = (degrees 270.0)
                 , velocity  = 1.0
                 }
               , { x = -1, y = 0 })
        (-90) -> ( { direction = (degrees -90.0)
                 , velocity  = 1.0
                 }
               , { x = -1, y = 0 })
        315 -> ( { direction = (degrees 315.0)
                 , velocity  = 1.0
                 }
               , { x = -1, y =-1 })
        (-45) -> ( { direction = (degrees -45.0)
                  , velocity  = 1.0
                  }
                , { x = -1, y =-1 })
        0   -> ( { direction = (degrees 0.0)
                 , velocity  = 1.0
                 }
               , { x =  0, y =-1 })
        45  -> ( { direction = (degrees 45.0)
                 , velocity  = 1.0
                 }
               , { x =  1, y =-1 })
        (-315) -> ( { direction = (degrees 315.0)
                  , velocity  = 1.0
                  }
                , { x =  1, y =-1 })
        90  -> ( { direction = (degrees 90.0)
                 , velocity  = 1.0
                 }
               , { x =  1, y = 0 })
        (-270) -> ( { direction = (degrees -270.0)
                  , velocity  = 1.0
                  }
                , { x =  1, y = 0 })        
        135 -> ( { direction = (degrees 135.0)
                 , velocity  = 1.0
                 }
               , { x =  1, y = 1 })
        (-225) -> ( { direction = (degrees -225.0)
                  , velocity  = 1.0
                  }
                , { x =  1, y = 1 })
        _ -> ( { direction = (degrees 0)    -- shouldn't happen
               , velocity  = 0
               }
             , { x =  0, y = 0 })
        
makeAttitude : Direction -> Keys -> (Attitude, Vector)
makeAttitude direction keys =
    let
        dx = Zero
           |> iff keys.left  prev
           |> iff keys.right succ
        dy = Zero
           |> iff keys.up    prev
           |> iff keys.down  succ
    in
        case (dx, dy) of
            (Zero,     Zero    ) -> ( { direction = direction
                                      , velocity = 0.0
                                      }
                                    , { x =  0, y = 0 })
            (Zero,     Positive) -> fromDirection 180
            (Negative, Positive) -> fromDirection 225
            (Negative, Zero    ) -> fromDirection 270
            (Negative, Negative) -> fromDirection 315
            (Zero,     Negative) -> fromDirection 0
            (Positive, Negative) -> fromDirection 45
            (Positive, Zero    ) -> fromDirection 90
            (Positive, Positive) -> fromDirection 135        
            
updateGeometry : Keys -> Geometry.Geometry -> Geometry.Geometry
updateGeometry keys geometry =
    let
        (attitude, vector) = makeAttitude geometry.attitude.direction keys
        vector' = { vector | x = vector.x * 3
                           , y = vector.y * 3 }
        position = Geometry.updatePosition vector' geometry.position
    in
        { geometry | attitude = attitude
                   , position = position
        }

updateDoing : Keys -> List Player.Types.Action
updateDoing keys =
    if keys.enter then
        [Player.Types.Attacking]
    else
        []
            
updatePlayer : Keys -> Player -> Player
updatePlayer keys player =
    { player | doing = updateDoing keys
             , geometry = updateGeometry keys player.geometry
    }

{- - Zombie[start]
The Zombie's direction will always point to the closest non-zombie
This may become the change of direction that requires the least amount of energy

Position -> Position -> Direction

-- Zombie[end] -}

newZombiePosition : Position -> Position -> Direction
newZombiePosition zPosition pPosition =
    Geometry.angleBetween zPosition pPosition

updateZombie : Position -> Geometry.Geometry -> Geometry.Geometry
updateZombie playerPosition zombie =
    let
        direction = Geometry.angleBetween zombie.position playerPosition
        direction' = 45 * round (Geometry.toDegrees direction / 45)
        (attitude', vector) = fromDirection direction'
        position' = Geometry.updatePosition vector zombie.position
    in
        { zombie | attitude = attitude'
                 , position = position' }
      
updateModel : Time -> Model -> Model
updateModel _ model =
    let
        {keys, player} = model
        player' = updatePlayer keys player
        zombie' = updateZombie player'.geometry.position model.zombie
    in
       {  model | player = player'
                , zombie = zombie'
       }

{- SPEC
WindowResize updates the window size
KeyChange updates model.keys and player.geometry.attitude
TimeUpdate updates the model
-}            
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        WindowResizeError error  -> ( model, Cmd.none )
        WindowResizeSuccess size -> ( { model | wsize = { width  = size.width  -- 3
                                                        , height = size.height -- 3
                                                        }
                                      }
                                    , Cmd.none
                                    )
        KeyChange  updateKeysFn  -> ( { model | keys = updateKeysFn model.keys }, Cmd.none )
        TimeUpdate dt            -> ( updateModel dt model, Cmd.none )

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.downs (keyChange True)
        , Keyboard.ups   (keyChange False)
        , AnimationFrame.diffs TimeUpdate
        , Window.resizes WindowResizeSuccess
        ]

windowSize : Task Error Window.Size -> Cmd Msg
windowSize t =
    Task.perform WindowResizeError WindowResizeSuccess t
