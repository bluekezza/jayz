module State exposing (..)

import AnimationFrame
import Player.State
import Geometry exposing (Side(..), Direction, Attitude, Position)
import Player.Types exposing (Player)
-- import Time exposing (..)
import Char
import Keyboard
import Window exposing (Size)
import Types exposing (..)
import Maybe exposing (..)
import Http exposing (Error)
import Task exposing (Task)

initialState : ( Model, Cmd Msg )
initialState =
    ( { wsize = { width = 800, height = 800 }
      , player = Player.State.initialState
      , keys = { left  = False
               , right = False
               , up    = False
               , down  = False
               , enter = False
               }
      }
    , Cmd.batch
        [ Window.size |> windowSize ]
    )

keyMap : Int -> Maybe Player.Types.Msg
keyMap keyCode =
    case (Char.fromCode keyCode) of
        'a' -> Just (Player.Types.Move Left)
        'd' -> Just (Player.Types.Move Right)
        's' -> Just (Player.Types.Move Down)
        'w' -> Just (Player.Types.Move Right)
        ' ' -> Just (Player.Types.Attack)
        _   -> Nothing

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
            if (Debug.log "key" key) == a then
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

-- press 'a' and you translate left
-- press 'd' and you translate right
-- press 's' and you translate down
-- press 'w' and you translate up
-- if 2 keys are pressed, then their effects are combined            actOn : Model -> Model
{-
actOn : Model -> Model
actOn model =
    if model.keys.enter == True then
        let
            player = model.player
            player1 = { player | doing = Attacking }
        in 
            { model | player = player1 }
-}

makeAttitude : Keys -> (Int, Int)
makeAttitude keys =
    let
        dx :Int
        dx = 0
        dy : Int
        dy = 0
        dx1 = if keys.left then
                  dx - 1
              else
                  dx
        dx2 = if keys.right then
                  dx1 + 1
              else
                  dx1
        dy1 = if keys.up then
                  dy + 1
              else
                  dy
        dy2 = if keys.down then
                  dy1 - 1
              else
                  dy1
        -- (direction, velocity) = case (Debug.log "(dx,dy)" (dx2, dy2)) of
        --                             (0 , 0) -> ( 0.0  , 0.0 ) -- nothing ( geometry.direction, 0.0 ) -- direction remains the same, but velocity is zero
        --                             (0 , 1) -> ( 0.0  , 1.0 ) -- up
        --                             (0 ,-1) -> ( 180.0, 1.0 ) -- down
        --                             (1 , 0) -> ( 90.0 , 1.0 ) -- right
        --                             (1 , 1) -> ( 45.0 , 1.0 ) -- right + up
        --                             (1 ,-1) -> ( 135.0, 1.0 ) -- right + down
        --                             (-1, 0) -> ( 270.0, 1.0 ) -- left
        --                             (-1, 1) -> ( 315.0, 1.0 ) -- left + up
        --                             (-1,-1) -> ( 225.0, 1.0 ) -- left + down
        --                             _       -> ( 0.0  , 0.0 ) -- this is a smell!!!
    in
        (dx2, dy2)

updatePosition : (Int, Int) -> Position -> Position
updatePosition (dx, dy) {x, y} =
    { x = x + dx, y = y + dy }
        
updateGeometry : Keys -> Geometry.Geometry -> Geometry.Geometry
updateGeometry keys geometry =
    let
        attitude = makeAttitude keys
        position = updatePosition attitude geometry.position
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
            
updateModel : Model -> Model
updateModel model =
    let
        {keys, player} = model
        player' = updatePlayer keys player
    in
        { model | player = player' }

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
        TimeUpdate dt            -> ( updateModel model, Cmd.none )

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
