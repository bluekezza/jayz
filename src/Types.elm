module Types exposing (..)

import Player.Types
import Time exposing (..)
import Keyboard exposing (KeyCode)
import Window exposing (Size)
import Http exposing (Error)
    
-- https://github.com/krisajenkins/elm-rays/blob/master/src/Types.elm
-- http://lexi-lambda.github.io/blog/2015/11/06/functionally-updating-record-types-in-elm/

type alias Keys =
    { left  : Bool
    , right : Bool
    , up    : Bool
    , down  : Bool
    , space : Bool
    }

type alias Model =
    { player : Player.Types.Model
    , wsize : { width : Int, height : Int }
    , keys : Keys
    }
    
type Msg
    = TimeUpdate Time
    | KeyDown KeyCode
    | KeyUp KeyCode
    | KeyChange (Keys -> Keys)
    | WindowResizeError Error
    | WindowResizeSuccess Size
    -- | PlayerMsg Player.Types.Msg

{-
Add model.velocity, this will simplify the translate code
As you just translate the player along the direction based on the length calculated from the velocity
-}

