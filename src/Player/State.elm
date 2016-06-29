module Player.State exposing (..)

import Geometry exposing (..)

import Player.Types exposing (..)

-- SPEC
initialState : Model
initialState =                              -- The player starts 
    { geometry = 
          { position = { x = 0.0, y = 0.0 } -- in the middle of the window
          , direction = 0.0                 -- in a neutral direction
          , velocity  = 0.0                 -- standing still
          }
    , doing     = Nothing                   -- doing nothing
    , holding   = Nothing                   -- holding nothing
    }

-- SPEC (for asteroids style movement)
{-
mkAction'' : Msg -> Direction -> Geometry.Action
mkAction'' (Turn AntiClockwise) direction = Rotate    (leftOf  geometry.direction 15.0)       -- When a player turns (anti)clockwise they are rotated 15 degrees of the players current direction
mkAction'' (Turn Clockwise)     direction = Rotate    (rightOf geometry.direction 15.0)
mkAction'' (Strafe Left)        direction = Translate (leftOf  geometry.direction 90  ) 15.0  -- When a player strafes they are translated 90 to their current direction
mkAction'' (Strafe Right)       direction = Translate (rightOf geometry.direction 90  ) 15.0
mkAction'' (Move Forward)       direction = Translate geometry.direction                20.0  -- When a player moves they are translated along the axis of their current direction
mkAction'' (Move Backward)      direction = Translate (opposite geometry.direction)     10.0  -- , but can move further forward than backward (their speed should be changed)
-}

-- SPEC?
mkAction : Geometry.Side -> Geometry.Action            
mkAction side =
    case side of
        Up    -> Translate 0.0   15.0
        Down  -> Translate 180.0 15.0
        Left  -> Translate 270.0 15.0
        Right -> Translate 90.0  15.0

--DSL for movement
type alias Vector = (Direction, Length)

update : Msg -> Player -> Player
update msg player =
    case msg of
        Move side -> let
            action = mkAction side
          in
            { player | geometry = Geometry.act action player.geometry }
        Attack -> player -- 
        Suffer -> player -- player.health - blow
