module View exposing (root)

-- import List exposing (concat)
import Html exposing (Html, div, ul, li, text)
import Types exposing (..)
import Geometry exposing (Geometry, toDegrees)

import Svg exposing (Svg, svg, rect, circle, ellipse, line, g)
import Svg.Attributes exposing (x, y, width, height, viewBox, r, rx, ry, fill, stroke, strokeWidth, style, x1, x2, y1 ,y2, cx, cy, transform)

actor : Geometry -> String -> Svg msg
actor geometry color =
    rect [ x (toString geometry.position.x), y (toString geometry.position.y), width "10", height "10", rx "2", ry "2", fill color] []

player : Geometry -> Svg msg
player geometry =
    let
        cx' = toFloat geometry.position.x
        cy' = toFloat geometry.position.y
        rx' = 70
        ry' = 40
        shoulderRadius = 25
        shoulderOffset = 70
        headToShoulder = 80
        headToChest = 44
        xOffsetToWeapon = 45
        yOffsetToWeapon = 35
        weaponLength = 102
        weaponWidth = 8
        ratio = 0.15
    in
        g [transform ("rotate("
                       ++ (toString (toDegrees geometry.attitude.direction))
                       ++ " "
                       ++ (toString cx')
                       ++ " "
                       ++ (toString cy')
                       ++ ")")]
             [-- shoulder left
              circle  [ cx (toString (cx' - (shoulderOffset * ratio)))
                      , cy (toString cy')
                      , r  (toString (shoulderRadius * ratio))
                      , stroke "black"
                      , strokeWidth "0"
                      , fill "green"]
                  []
             -- shoulder right
             ,circle  [ cx (toString (cx' + (shoulderOffset * ratio)))
                      , cy (toString cy')
                      , r  (toString (shoulderRadius * ratio))
                      , stroke "black"
                      , strokeWidth "0"
                      , fill "green"]
                  []
             -- torso
             ,ellipse [ cx (toString cx')
                      , cy (toString cy')
                      , rx (toString (headToShoulder * ratio))
                      , ry (toString (headToChest * ratio))
                      , style "fill:green;stroke:purple;stroke-width:0"]
                  []
             -- head
             ,circle  [ cx (toString cx')
                      , cy (toString cy')
                      , r  (toString (ry' * ratio))
                      , stroke "black"
                      , strokeWidth "0"
                      , fill "brown"]
                  []
             -- weapon
             ,line    [ x1 (toString (cx' + (xOffsetToWeapon * ratio)))
                      , y1 (toString (cy' - (weaponLength * ratio)))
                      , x2 (toString (cx' + (xOffsetToWeapon * ratio)))
                      , y2 (toString (cy' - (yOffsetToWeapon * ratio)))
                      , style ("stroke:rgb(0,0,0);stroke-width:" ++ (toString (weaponWidth * ratio)))]
                  []
             ]

zombie : Geometry -> Svg msg
zombie geometry =
    let
        cx' = toFloat geometry.position.x
        cy' = toFloat geometry.position.y
        rx' = 70
        ry' = 40
        shoulderRadius = 25
        armLength = 100
        armWidth = 20
        shoulderOffset = 70
        headToShoulder = 80
        headToChest = 44
        xOffsetToWeapon = 45
        yOffsetToWeapon = 35
        weaponLength = 102
        weaponWidth = 8
        ratio = 0.15
        bodyColor = "purple"
        headColor = "green"
    in
        g [transform ("rotate("
                       ++ (toString (toDegrees geometry.attitude.direction))
                       ++ " "
                       ++ (toString cx')
                       ++ " "
                       ++ (toString cy')
                       ++ ")")]
             -- shoulder left
            [line    [ x1 (toString (cx' - (shoulderOffset * ratio)))
                     , y1 (toString cy')
                     , x2 (toString (cx' - (shoulderOffset * ratio)))
                     , y2 (toString (cy' - (armLength * ratio)))
                     , style ("stroke:" ++ bodyColor ++ ";stroke-width:" ++ (toString (armWidth * ratio)))]
                 []
             -- shoulder right
            ,line    [ x1 (toString (cx' + (shoulderOffset * ratio)))
                     , y1 (toString cy')
                     , x2 (toString (cx' + (shoulderOffset * ratio)))
                     , y2 (toString (cy' - (armLength * ratio)))
                     , style ("stroke:" ++ bodyColor ++ ";stroke-width:" ++ (toString (armWidth * ratio)))]
                 []
             -- torso
             ,ellipse [ cx (toString cx')
                      , cy (toString cy')
                      , rx (toString (headToShoulder * ratio))
                      , ry (toString (headToChest * ratio))
                      , style ("fill:" ++ bodyColor ++ ";stroke:purple;stroke-width:0")]
                  []
             -- head
             ,circle  [ cx (toString cx')
                      , cy (toString cy')
                      , r  (toString (ry' * ratio))
                      , stroke "black"
                      , strokeWidth "0"
                      , fill headColor]
                  []

             ]

board : Model -> Html msg
board model =
    let
        w = 300
        h = 500
    in
        svg
        [ width (toString (model.wsize.width - w)), height (toString (model.wsize.height - h)), viewBox ("0 0 " ++ (toString (model.wsize.width - w)) ++ " " ++ (toString (model.wsize.height - h)))]
        [ player model.player.geometry
        , zombie model.zombie
        ]

renderGeometry : Geometry.Geometry -> Html Msg
renderGeometry geometry =
    ul []
        [li [] [ text "Geometry"
               , ul []
                   [ li [] [ text "attitude: "
                           , ul []
                               [ li [] [ text "direction: "
                                       , text (toString (Geometry.toDegrees geometry.attitude.direction))
                                       ]
                               , li [] [ text "velocity: "
                                       , text (toString geometry.attitude.velocity)
                                      ]
                                   
                                ]]
                   , li [] [ text ("position: " ++ toString geometry.position)]
                   ]]]

diagnostics : Model -> Html Msg
diagnostics model =
    div []
        [text "Model"
        ,ul []
            [li [] [ text ("Window: " ++ toString model.wsize ) ]
            ,li [] [ text ("Keys  : " ++ toString model.keys) ]
            ,li [] [ text "Player: "
                    , ul [] [ li [] [ text ("holding: " ++ toString model.player.holding) ]
                            , li [] [ text ("doing: " ++ toString model.player.doing) ]
                            , renderGeometry model.player.geometry
                            ]]
            , li [] [ text "Zombie: "
                    , renderGeometry model.zombie
                    ]
             ]]
        
root : Model -> Html Msg
root model =
    div []
        [ board model
        , diagnostics model ]
