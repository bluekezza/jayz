module Geometry exposing (..)

type alias Position = { x : Int, y : Int }
type alias Radians = Float
type alias Angle    = Radians
type alias Velocity = Float
type alias Length   = Float
type alias Direction = Angle

-- x, y
type alias Vector = Position -- (Int, Int)
    
type alias Attitude =
    { direction : Direction
    , velocity  : Velocity
    }
      
type alias Geometry =
    { position  : Position
    , attitude  : Attitude
    }

updatePosition : Vector -> Position -> Position
updatePosition vector position =
    { x = position.x + vector.x, y = position.y + vector.y }


-- http://uk.mathworks.com/matlabcentral/answers/180131-how-can-i-find-the-angle-between-two-vectors-including-directional-information?
angleBetween : Position -> Position -> Direction
angleBetween from to =
    let
        unitVector = { x = 0, y = 1 }
        fromToVector = { x = from.x - to.x, y = from.y - to.y }
    in
        angleBetweenVectors unitVector fromToVector

angleBetweenVectors : Vector -> Vector -> Direction
angleBetweenVectors v1 v2 =
    let
        x1 = toFloat v1.x
        y1 = toFloat v1.y
        x2 = toFloat v2.x
        y2 = toFloat v2.y
        a = atan2 (x1 * y2 - y1 * x2) (x1 * x2 + y1 * y2)
    in
        a
        
{-
angleBetweenTest : Bool
angleBetweenTest : Bool
  let
    fixtures : List (Position, Position, Degree)
    fixtures = [ ( { x = 0, y = 1 }, { x =  0, y =  1 }, 0.0   )
                 ( { x = 0, y = 1 }, { x = -1, y =  1 }, 45.0  )
                 ( { x = 0, y = 1 }, { x = -1, y =  0 }, 90.0  )
                 ( { x = 0, y = 1 }, { x = -1, y = -1 }, 135.0 )
                 ( { x = 0, y = 1 }, { x =  0, y = -1 }, 180.0 )
                 ( { x = 0, y = 1 }, { x =  1, y = -1 }, 225.0 )
                 ( { x = 0, y = 1 }, { x =  1, y =  0 }, 270.0 )
               ]
     runner = \(from, to, expectedOut) -> toDegrees (angleBetween from to)
     results = map runner fixtures
     combined = zip fixtures results ; [(Fixture, Result]

toDegrees (angleBetween { x = 0, y = 1 } { x =  1, y =  1 }) -- 315.0  -45
toDegrees (angleBetween { x = 0, y = 1 } { x =  0, y =  1 }) -- 0.0
toDegrees (angleBetween { x = 0, y = 1 } { x = -1, y =  1 }) -- 45.0
toDegrees (angleBetween { x = 0, y = 1 } { x = -1, y =  0 }) -- 90.0
toDegrees (angleBetween { x = 0, y = 1 } { x = -1, y = -1 }) -- 135.0
toDegrees (angleBetween { x = 0, y = 1 } { x =  0, y = -1 }) -- 180.0  -180
toDegrees (angleBetween { x = 0, y = 1 } { x =  1, y = -1 }) -- 225.0  -135
toDegrees (angleBetween { x = 0, y = 1 } { x =  1, y =  0 }) -- 270.0  -90
toDegrees (angleBetween { x = 0, y = 1 } { x =  1, y =  1 }) -- 315.0  -45
-}

toDegrees : Float -> Float
toDegrees radians = radians * (180 / pi)
