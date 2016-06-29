module Geometry exposing (..)

import Time exposing (Time)

type alias Position = { x : Length, y : Length }
type alias Angle    = Float
type alias Velocity = Float
type alias Length   = Float
type alias Direction = Angle

type Side
    = Up
    | Down
    | Left
    | Right
    
type alias Geometry =
    { position  : Position
    , direction : Direction
    , velocity  : Velocity
    }             
    
type Action
    = Rotate    Angle
    | Translate Angle Length

rotate : Angle -> Geometry -> Geometry
rotate angle geometry = geometry

translate : Angle -> Length -> Geometry -> Geometry
translate angle length geometry = geometry

applyPhysics : Time -> Geometry -> Geometry
applyPhysics dt geometry =
    let
        length = geometry.velocity * dt
        -- todo need to apply the physics along the direction we are pointing
    in
        geometry
        -- { geometry | position = geometry.position + length}
        
act : Action -> Geometry -> Geometry
act action geometry =
    case action of
        (Rotate    angle)            -> rotate angle geometry
        (Translate direction length) -> translate direction length geometry

updateVelocity : Float -> Geometry -> Geometry
updateVelocity newVelocity geometry =
    { geometry | velocity = newVelocity }
