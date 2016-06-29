module Player.Types exposing (..)

import Geometry
import Maybe exposing (..)
    
type alias Angle = Float
    
type alias Speed = Float
        
type alias Position =
    { x : Float
    , y : Float
    }

type Msg
    = Move Geometry.Side
    | Attack
    | Suffer

type Weapon
    = Magazine
    | Bag
    | Chair
    
type alias Model =
    { geometry : Geometry.Geometry
    , doing    : Maybe Msg
    , holding  : Maybe Weapon
    }

type alias Player = Model
