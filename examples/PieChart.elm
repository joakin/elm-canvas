module PieChart exposing (main)

import Browser
import Browser.Events exposing (onAnimationFrameDelta)
import Canvas exposing (..)
import Canvas.Settings exposing (..)
import Canvas.Settings.Advanced exposing (..)
import Canvas.Settings.Line exposing (..)
import Canvas.Settings.Text exposing (..)
import Color exposing (Color)
import Html exposing (Html)
import Html.Attributes as Attributes
import Time exposing (Posix)


main =
    view


w =
    500


h =
    500


view =
    let
        center =
            ( w / 2, h / 2 )

        radius =
            160
    in
    Canvas.toHtml
        ( w, h )
        []
        [ shapes [ fill Color.white ] [ rect ( 0, 0 ) w h ]
        , renderPieSlice Color.lightPurple center radius (degrees 0) (degrees 45)
        , renderPieSlice Color.lightRed center radius (degrees 45) (degrees 102)
        , renderPieSlice Color.lightGreen center radius (degrees 102) (degrees 210)
        , renderPieSlice Color.lightBlue center radius (degrees 210) (degrees 360)
        ]


renderPieSlice color (( x, y ) as center) radius startAngle endAngle =
    shapes [ fill color ]
        [ path center
            [ lineTo ( x + radius * cos startAngle, y + radius * sin startAngle )
            , lineTo ( x + radius * cos endAngle, y + radius * sin endAngle )
            , lineTo center
            ]
        , arc
            center
            radius
            { startAngle = startAngle
            , endAngle = endAngle
            , clockwise = True
            }
        ]
