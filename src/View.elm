module View exposing (root)

import Html exposing (Html, div, ul, li, text)
import Types exposing (..)

import Svg exposing (Svg, svg, rect)
import Svg.Attributes exposing (x, y, width, height, viewBox, rx, ry)

board : Model -> Html.Html msg
board model =
    let
        w = 50
        h = 50
    in
        svg
        [ width (toString (model.wsize.width - w)), height (toString (model.wsize.height - h)), viewBox ("0 0 " ++ (toString (model.wsize.width - w)) ++ " " ++ (toString (model.wsize.height - h)))]
        [ rect [ x (toString model.player.geometry.position.x), y (toString model.player.geometry.position.y), width "10", height "10", rx "2", ry "2" ] [] ]

diagnostics : Model -> Html Msg
diagnostics model =
    div []
        [text "Model"
        ,ul []
            [(li [] [ text ("Window: " ++ toString model.wsize )])
            ,(li [] [ text ("Keys  : " ++ toString model.keys)])
            ,(li [] [ text "Player: "
                    , (ul [] [(li [] [ text ("holding: " ++ toString model.player.holding)])
                             ,(li [] [ text ("doing: " ++ toString model.player.doing)])
                             ,(li [] [ text ("attitude: " ++ toString model.player.geometry.attitude)])
                             ,(li [] [ text ("position: " ++ toString model.player.geometry.position)])])])]]
        
root : Model -> Html Msg
root model =
    board model

