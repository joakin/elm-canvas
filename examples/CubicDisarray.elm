module Examples.CubicDisarray exposing (main)

{-| Based on:

  - <https://generativeartistry.com/tutorials/cubic-disarray/>

`https://media.vam.ac.uk/media/thira/collection_images/2009CD/2009CD4551_jpg_l.jpg`

-}

import Browser
import Canvas exposing (..)
import Color exposing (Color)
import Grid
import Html exposing (..)
import Html.Attributes exposing (..)
import Random
import Time exposing (Posix)


main : Program Float Model Msg
main =
    Browser.element { init = init, update = update, subscriptions = subscriptions, view = view }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


w =
    500


h =
    padding * 2 + rows * boxSize


padding =
    w / 6


cols =
    12


rows =
    20


boxSize =
    (w - padding * 2) / cols


type alias Model =
    ( Random.Seed, Int )


type Msg
    = AnimationFrame Float


init : Float -> ( Model, Cmd Msg )
init floatSeed =
    ( ( Random.initialSeed (floatSeed * 1000000 |> floor), 0 )
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AnimationFrame delta ->
            ( model |> Tuple.mapSecond ((+) 1)
            , Cmd.none
            )


bg =
    Color.hsl (degrees 39) 0.19 0.86


view : Model -> Html Msg
view ( seed, count ) =
    let
        background =
            shapes [ rect ( 0, 0 ) w h ]
                |> fill bg

        rectangles =
            drawRects seed []
    in
    Canvas.toHtml ( w, floor h ) [] (background :: rectangles)


drawRects seed rects =
    Grid.fold2d { rows = rows, cols = cols } drawRect ( rects, seed )
        |> Tuple.first


drawRect ( x, y ) ( rects, seed ) =
    let
        ( xf, yf ) =
            ( toFloat x, toFloat y )

        ( px, py ) =
            ( xf * boxSize + padding, yf * boxSize + padding )

        ( ( rotateAmt, translateAmt ), newSeed ) =
            moveAround ( xf, yf ) seed
    in
    ( (shapes [ rect ( 0, 0 ) boxSize boxSize ]
        |> transform [ translate (px + translateAmt) py, rotate rotateAmt ]
        |> stroke Color.black
      )
        :: rects
    , newSeed
    )


randomDisplacement =
    15


rotateMultiplier =
    45


randomFloat =
    Random.float 0 1


fourRandomFloats =
    Random.map4 (\r1 r2 r3 r4 -> ( ( r1, r2 ), ( r3, r4 ) )) randomFloat randomFloat randomFloat randomFloat


moveAround ( x, y ) seed =
    let
        ( ( ( r1, r2 ), ( r3, r4 ) ), seed2 ) =
            Random.step fourRandomFloats seed

        plusOrMinus r =
            if r < 0.5 then
                -1

            else
                1

        rotateAmt =
            y / rows * pi / 180 * plusOrMinus r1 * r2 * rotateMultiplier

        translateAmt =
            y / rows * plusOrMinus r3 * r4 * randomDisplacement
    in
    ( ( rotateAmt, translateAmt ), seed2 )
