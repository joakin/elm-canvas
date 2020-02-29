module TiledLines exposing (main)

import Browser
import Browser.Events exposing (onAnimationFrame)
import Canvas exposing (..)
import Canvas.Settings exposing (..)
import Canvas.Settings.Line exposing (..)
import Color exposing (Color)
import Html exposing (..)
import Html.Attributes exposing (..)
import Random
import Task
import Time exposing (Posix)


main : Program Float Model ()
main =
    Browser.element
        { init = \floatSeed -> ( { seed = Random.initialSeed (floor (floatSeed * 10000)) }, Cmd.none )
        , update = \_ m -> ( m, Cmd.none )
        , subscriptions = \_ -> Sub.none
        , view = view
        }


h : number
h =
    500


w : number
w =
    500


padding : number
padding =
    20


type alias Point =
    ( Float, Float )


type alias Line =
    ( Point, Point )


type alias Model =
    { seed : Random.Seed
    }


view : Model -> Html ()
view model =
    Canvas.toHtml
        ( w, h )
        []
        [ shapes [ fill Color.white ] [ rect ( 0, 0 ) w h ]
        , shapes
            [ stroke Color.black
            , lineWidth 2
            ]
            (drawLines model.seed 0 [])
        ]


step =
    5


cols =
    w // step


rows =
    h // step


drawLines : Random.Seed -> Int -> List Shape -> List Shape
drawLines seed i shapes =
    if i > cols * rows then
        shapes

    else
        let
            x =
                modBy cols i

            y =
                i // rows

            ( line, seed2 ) =
                randomLine seed (toFloat x * step) (toFloat y * step) step step

            lineShapes =
                drawLine line
        in
        drawLines seed2 (i + 1) (lineShapes :: shapes)


randomLine seed x y width height =
    -- horizontalLine seed x y width height
    diagonalLine seed x y width height


randomBool =
    Random.map (\n -> n < 0.5) (Random.float 0 1)


diagonalLine seed x y width height =
    Random.step randomBool seed
        |> Tuple.mapFirst
            (\bool ->
                if bool then
                    ( ( x, y ), ( x + width, y + height ) )

                else
                    ( ( x + width, y ), ( x, y + height ) )
            )


horizontalLine seed x y width height =
    Random.step randomBool seed
        |> Tuple.mapFirst
            (\bool ->
                if bool then
                    ( ( x + width / 2, y ), ( x + width / 2, y + height ) )

                else
                    ( ( x, y + height / 2 ), ( x + width, y + height / 2 ) )
            )


drawLine ( start, end ) =
    path start [ lineTo end ]
