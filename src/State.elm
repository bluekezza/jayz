module State exposing (..)

import AnimationFrame
import Player.State
import Geometry exposing (Side(..), Direction)
import Player.Types exposing (Player)
-- import Time exposing (..)
import Char
import Keyboard
import Window exposing (Size)
import Types exposing (..)
import Maybe exposing (..)
import Http exposing (Error)
import Task exposing (Task)

type alias Player = Model

initialState : ( Model, Cmd Msg )
initialState =
    ( { wsize = { width = 800, height = 800 }
      , player = Player.State.initialState
      , keys = { left  = False
               , right = False
               , up    = False
               , down  = False
               , space = False
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
pressing_the_space_key_makes_the_player_attack
pressing any other key does nothing
-}               
keyChange : Bool -> Keyboard.KeyCode -> Msg
keyChange on key =
    let
        a = 65
        d = 68
        w = 87
        s = 83
        space = 32
                
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
            else if key == space then
                \k -> { k | space = on }
            else
                Basics.identity
    in
        KeyChange updateKeysFn

-- press 'a' and you translate left
-- press 'd' and you translate right
-- press 's' and you translate down
-- press 'w' and you translate up
-- if 2 keys are pressed, then their effects are combined
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case (Debug.log "msg" msg) of
        TimeUpdate dt            -> ( model, Cmd.none )
        KeyDown    keyCode       -> ( model, Cmd.none )
        KeyUp      keyCode       -> ( model, Cmd.none )
        KeyChange  updateKeysFn  -> ( { model | keys = updateKeysFn model.keys }, Cmd.none )
        WindowResizeError error  -> ( model, Cmd.none )
        WindowResizeSuccess size -> ( { model | wsize = { width  = size.width  -- 3
                                                        , height = size.height -- 3
                                                        }
                                      }
                                    , Cmd.none
                                    )

-- TODO: cancel the speed if the key is not being pressed
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
