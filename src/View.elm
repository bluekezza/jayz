module View exposing (root)

import Html exposing (..)
-- import Html.Events exposing (..)
import Types exposing (..)

root : Model -> Html Msg
root model =
    div []
        [ p []
            [ text ("Model: " ++ toString model) ]]
        {-
        , button [ onClick (PlayerMsg (Turn 1.0)) ]
            [ text "Turn" ]
        , button [ onClick (ActivityMsg (Move 1.0)) ]
            [ text "Move" ]
        , button [ onClick (ActivityMsg Attack) ]
            [ text "Attack" ]
        -}
