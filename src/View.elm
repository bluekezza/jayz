module View exposing (root)

import Html exposing (..)
-- import Html.Events exposing (..)
import Types exposing (..)

root : Model -> Html Msg
root model =
    div [] [text "Model"
           ,ul []
               [(li [] [ text ("Window: " ++ toString model.wsize )])
               ,(li [] [ text ("Keys  : " ++ toString model.keys)])
               ,(li [] [ text "Player: "
                       , (ul [] [(li [] [ text ("holding: " ++ toString model.player.holding)])
                                ,(li [] [ text ("doing: " ++ toString model.player.doing)])
                                ,(li [] [ text ("attitude: " ++ toString model.player.geometry.attitude)])
                                ,(li [] [ text ("position: " ++ toString model.player.geometry.position)])])])]]

