module Examples.NewApiTest exposing (main)

import Browser
import Browser.Events exposing (onAnimationFrameDelta)
import Canvas exposing (..)
import Canvas.Color as Color exposing (Color)
import Html exposing (Html)
import Html.Attributes as Attributes
import Random
import Time exposing (Posix)


main : Program () ( Float, Float ) Float
main =
    Browser.element
        { init = \_ -> ( ( 0, 0 ), Cmd.none )
        , update = \dt ( count, fps ) -> ( ( count + 1, 1000 / dt ), Cmd.none )
        , subscriptions = \_ -> onAnimationFrameDelta identity
        , view = view
        }


w =
    500


h =
    500


step =
    20


view ( count, fps ) =
    Canvas.toHtml
        ( w, h )
        [ Attributes.style "border" "2px solid red" ]
    <|
        [ shapes [ rect ( 0, 0 ) w h ] |> fill Color.white
        , shapes
            [ rect ( -100, -150 ) 40 50
            , moveTo ( 100, 100 )
            , circle ( 100, 100 ) 80
            ]
            |> lineWidth 5
            |> transform [ translate (w / 2) (h / 2), rotate (degrees (sin (count / 100) * 360)) ]
            |> fill Color.red
            |> stroke Color.green
        , text ( w - 50, 50 ) ("fps: " ++ String.fromInt (floor fps))
            |> align Right
            |> size 30
            |> family "sans-serif"
            |> lineWidth 1
            |> stroke Color.blue
            |> fill Color.green
        , shapes
            [ moveTo ( 20, 10 )
            , lineTo ( 10, 30 )
            , lineTo ( 30, 30 )
            , lineTo ( 20, 10 )
            ]
        ]
