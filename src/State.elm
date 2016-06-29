module State exposing (..)

import AnimationFrame
import Player.State
import Geometry exposing (Side(..), Direction)
import Player.Types exposing (Player)
-- import Time exposing (..)
import Char
import Keyboard
-- import Window
import Types exposing (..)
import Maybe exposing (..)

type alias Player = Model

initialState : ( Model, Cmd Msg )
initialState =
    ( { wsize = { width = 800, height = 800 }
      , player = Player.State.initialState
      }
    , Cmd.none
    -- , Cmd.batch
    --     [ Window.size |> windowSize
    --     ]
    )

{-
windowSize : Task Error Window.Size -> Cmd Msg
windowSize t =
    Task.perform WindowSizeError WindowSizeSuccess t
-}
    
-- pressing_the_a_key_makes_the_player_turn_left
-- pressing_the_d_key_makes_the_player_turn_right
-- pressing_the_w_key_makes_the_player_move_forward
-- pressing_the_s_key_makes_the_player_move_backward
-- pressing_the_space_key_makes_the_player_attack
-- pressing any other key does nothing
keyMap : Int -> Maybe Player.Types.Msg
keyMap keyCode =
    case (Char.fromCode keyCode) of
        'a' -> Just (Player.Types.Move Left)
        'd' -> Just (Player.Types.Move Right)
        's' -> Just (Player.Types.Move Down)
        'w' -> Just (Player.Types.Move Right)
        ' ' -> Just (Player.Types.Attack)
        _   -> Nothing

-- press 'a' and you translate left
-- press 'd' and you translate right
-- press 's' and you translate down
-- press 'w' and you translate up
-- if 2 keys are pressed, then their effects are combined
               
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case (Debug.log "msg" msg) of
        TimeUpdate dt   -> ( model, Cmd.none )
        KeyDown keyCode -> ( model, Cmd.none )
        KeyUp   keyCode -> ( model, Cmd.none )

-- TODO: cancel the speed if the key is not being pressed
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ AnimationFrame.diffs TimeUpdate
        , Keyboard.downs KeyDown
        , Keyboard.ups   KeyUp
        -- , every second Tick
        -- , Window.resizes WindowSizeSuccess
        ]
