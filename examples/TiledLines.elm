module Examples.TiledLines exposing (main)

import Browser
import Browser.Events exposing (onAnimationFrame)
import Canvas exposing (..)
import CanvasColor as Color exposing (Color)
import Html exposing (..)
import Html.Attributes exposing (..)
import Random
import Task
import Time exposing (Posix)


main : Program Float Model Msg
main =
    Browser.element { init = init, update = update, subscriptions = subscriptions, view = view }


subscriptions : Model -> Sub Msg
subscriptions model =
    -- AF.diffs AnimationFrame
    Sub.none


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


type Msg
    = AnimationFrame Posix


init : Float -> ( Model, Cmd Msg )
init floatSeed =
    ( { seed = Random.initialSeed (floor (floatSeed * 10000)) }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AnimationFrame delta ->
            ( model
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    Canvas.element
        w
        h
        []
        (empty
            |> clearRect 0 0 w h
            |> lineWidth 2
            |> beginPath
            |> drawLines model.seed 0
            |> stroke
        )


step =
    5


cols =
    w // step


rows =
    h // step


drawLines : Random.Seed -> Int -> Commands -> Commands
drawLines seed i cmds =
    if i > cols * rows then
        cmds

    else
        let
            x =
                modBy cols i

            y =
                i // rows

            ( line, seed2 ) =
                randomLine seed (toFloat x * step) (toFloat y * step) step step

            lineCmds =
                drawLine line cmds
        in
        drawLines seed2 (i + 1) lineCmds


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


drawLine ( ( startX, startY ), ( endX, endY ) ) cmds =
    cmds
        |> moveTo startX startY
        |> lineTo endX endY
