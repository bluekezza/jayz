module Geometry exposing (..)

type alias Position = { x : Int, y : Int }
type alias Angle    = Float
type alias Velocity = Float
type alias Length   = Float
type alias Direction = Angle

type alias Attitude = ( Int, Int )
      
type alias Geometry =
    { position : Position
    , attitude : Attitude
    }
