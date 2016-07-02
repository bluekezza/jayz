module Player.State exposing (..)

import Player.Types exposing (..)

-- SPEC
initialState : Model
initialState =                          -- The player starts 
    { geometry = 
          { position = { x = 0, y = 0 } -- in the middle of the window
          , attitude =
                { direction = 0.0
                , velocity = 0.0
                }
          }
    , doing     = []                    -- doing nothing
    , holding   = Just Player.Types.Axe
    }
