module Player.Types exposing (..)

import Geometry
import Maybe exposing (..)
    
type alias Angle = Float
    
type alias Speed = Float
        
type Msg
    = Move Geometry.Side
    | Attack
    | Suffer

type Weapon
    = Magazine
    | Bag
    | Chair
    | Axe

type Action
    = Attacking
    | Suffering
    | Moving

type alias Model =
    { geometry : Geometry.Geometry
    , doing    : List Action
    , holding  : Maybe Weapon
    }

type alias Player = Model
