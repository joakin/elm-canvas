module Examples.TiledLines exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Time exposing (Time)
import Canvas exposing (..)
import Color exposing (Color)
import Random
import Task
import AnimationFrame as AF


main : Program Float Model Msg
main =
    Html.programWithFlags { init = init, update = update, subscriptions = subscriptions, view = view }


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
    , draw : Command
    }


type Msg
    = AnimationFrame Time


init : Float -> ( Model, Cmd Msg )
init floatSeed =
    { seed = Random.initialSeed (floor (floatSeed * 10000))
    , draw = batch []
    }
        ! [ Task.perform AnimationFrame (Task.succeed 0) ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AnimationFrame delta ->
            { model
                | draw = batch <| drawLines model.seed 0 []
            }
                ! []


view : Model -> Html Msg
view model =
    Canvas.element
        w
        h
        [ style [] ]
        [ clearRect 0 0 w h
        , lineWidth 2
        , beginPath
        , model.draw
        , stroke
        ]


step =
    5


cols =
    w // step


rows =
    h // step


drawLines : Random.Seed -> Int -> List Command -> List Command
drawLines seed i cmds =
    if i > cols * rows then
        cmds
    else
        let
            x =
                i % cols

            y =
                i // rows

            ( line, seed2 ) =
                randomLine seed (toFloat x * step) (toFloat y * step) step step

            lineCmds =
                drawLine line
        in
            drawLines seed2 (i + 1) (List.concat [ lineCmds, cmds ])


randomLine seed x y width height =
    -- horizontalLine seed x y width height
    diagonalLine seed x y width height


diagonalLine seed x y width height =
    Random.step Random.bool seed
        |> Tuple.mapFirst
            (\bool ->
                if bool then
                    ( ( x, y ), ( x + width, y + height ) )
                else
                    ( ( x + width, y ), ( x, y + height ) )
            )


horizontalLine seed x y width height =
    Random.step Random.bool seed
        |> Tuple.mapFirst
            (\bool ->
                if bool then
                    ( ( x + width / 2, y ), ( x + width / 2, y + height ) )
                else
                    ( ( x, y + height / 2 ), ( x + width, y + height / 2 ) )
            )


drawLine ( ( startX, startY ), ( endX, endY ) ) =
    [ moveTo startX startY
    , lineTo endX endY
    ]
