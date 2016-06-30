module Geometry exposing (..)

type alias Position = { x : Int, y : Int }
type alias Angle    = Float
type alias Velocity = Float
type alias Length   = Float
type alias Direction = Angle

type Side
    = Up
    | Down
    | Left
    | Right

type alias Attitude = ( Int, Int )
      
type alias Geometry =
    { position : Position
    , attitude : Attitude
    }
    
type Action
    = Rotate    Angle
    | Translate Angle Length

rotate : Angle -> Geometry -> Geometry
rotate angle geometry = geometry

translate : Angle -> Length -> Geometry -> Geometry
translate angle length geometry = geometry

act : Action -> Geometry -> Geometry
act action geometry =
    case action of
        (Rotate    angle)            -> rotate angle geometry
        (Translate direction length) -> translate direction length geometry
