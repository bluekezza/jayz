module View exposing (root)

import Html exposing (Html, div, ul, li, text)
import Types exposing (..)
import Geometry exposing (Geometry)

import Svg exposing (Svg, svg, rect)
import Svg.Attributes exposing (x, y, width, height, viewBox, rx, ry, fill)

actor : Geometry -> String -> Svg msg
actor geometry color =
    rect [ x (toString geometry.position.x), y (toString geometry.position.y), width "10", height "10", rx "2", ry "2", fill color] []

board : Model -> Html msg
board model =
    let
        w = 300
        h = 300
    in
        svg
        [ width (toString (model.wsize.width - w)), height (toString (model.wsize.height - h)), viewBox ("0 0 " ++ (toString (model.wsize.width - w)) ++ " " ++ (toString (model.wsize.height - h)))]
        [ actor model.player.geometry "black"
        , actor model.zombie "red"
        ]

renderGeometry : Geometry.Geometry -> Html Msg
renderGeometry geometry =
    ul []
        [li [] [ text "Geometry"
               , ul []
                   [ li [] [ text ("direction: " ++ toString geometry.direction)]
                   , li [] [ text ("attitude: " ++ toString geometry.attitude)]
                   , li [] [ text ("position: " ++ toString geometry.position)]
                   ]]]
        
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
                             , renderGeometry model.player.geometry
                             ])])]]
        
root : Model -> Html Msg
root model =
    div []
        [ board model
        , diagnostics model ]

