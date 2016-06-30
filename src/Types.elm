module Types exposing (..)

import Player.Types
import Time exposing (..)
import Window exposing (Size)
import Http exposing (Error)

type alias Keys =
    { left  : Bool
    , right : Bool
    , up    : Bool
    , down  : Bool
    , enter : Bool
    }

type alias Model =
    { player : Player.Types.Model
    , wsize : { width : Int, height : Int }
    , keys : Keys
    }
    
type Msg
    = TimeUpdate Time
    | KeyChange (Keys -> Keys)
    | WindowResizeError Error
    | WindowResizeSuccess Size

