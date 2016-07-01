module Types exposing (..)

import Geometry exposing (Geometry)
import Http exposing (Error)
import Player.Types
import Time exposing (..)
import Window exposing (Size)

type alias Keys =
    { left  : Bool
    , right : Bool
    , up    : Bool
    , down  : Bool
    , enter : Bool
    }

type alias Model =
    { wsize : { width : Int, height : Int }
    , keys : Keys
    , player : Player.Types.Model
    , zombie : Geometry.Geometry
    }
    
type Msg
    = TimeUpdate Time
    | KeyChange (Keys -> Keys)
    | WindowResizeError Error
    | WindowResizeSuccess Size
