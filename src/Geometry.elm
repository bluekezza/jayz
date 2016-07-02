module Geometry exposing (..)

type alias Position = { x : Int, y : Int }
type alias Angle    = Float
type alias Velocity = Float
type alias Length   = Float
type alias Direction = Angle

type alias Vector = (Int, Int)
    
type alias Attitude =
    { direction : Direction
    , velocity  : Velocity
    }
      
type alias Geometry =
    { position  : Position
    , attitude  : Attitude
    }
