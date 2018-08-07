module Examples.JoyDivision exposing (main)

import Html exposing (..)
import Html.Attributes exposing (style)
import Time exposing (Time)
import Canvas exposing (..)
import Color exposing (Color)
import Random
import AnimationFrame as AF
import Matrix exposing (Matrix)
import Grid


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
    100


stepX =
    10


stepY =
    5


cols =
    (w - padding * 2) // stepX


rows =
    (h - padding * 2) // stepY


cells =
    (rows * cols)


type alias Points =
    Matrix { point : ( Float, Float ), random : Float }


type alias Model =
    { count : Int
    , points : Points
    }


type Msg
    = AnimationFrame Time


coordsToPx ( x, y ) =
    ( x * stepX + stepX / 2 + padding
    , y * stepY + stepY / 2 + padding * 1.3
    )


moveAround r ( x, y ) =
    let
        distanceToCenter =
            abs (x - w / 2)

        maxVariance =
            150

        p =
            ((w - padding * 2 - 100) / 2) / maxVariance

        variance =
            max (-distanceToCenter / p + maxVariance) 0

        random =
            r * variance / 2 * -1
    in
        ( x, y + random )


init : Float -> ( Model, Cmd Msg )
init floatSeed =
    let
        ( randomYs, seed ) =
            Random.initialSeed (floatSeed * 100000 |> floor)
                |> Random.step (Random.list rows (Random.list cols (Random.float 0 1)))
                |> Tuple.mapFirst (Matrix.fromList >> Maybe.withDefault Matrix.empty)

        points =
            Matrix.repeat cols rows ( 0, 0 )
                |> Matrix.indexedMap (\x y _ -> ( toFloat x, toFloat y ) |> coordsToPx)
                |> Matrix.map2 (\r p -> { point = moveAround r p, random = r }) randomYs
                |> Maybe.withDefault Matrix.empty
    in
        { count = 0, points = points } ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AnimationFrame delta ->
            { model | count = model.count + 1 } ! []


bgColor =
    Color.hsl (degrees 260) 0.1 0.1


view : Model -> Html Msg
view model =
    Canvas.element
        w
        h
        [ style [] ]
        (empty
            |> fillStyle bgColor
            |> fillRect 0 0 w h
            |> strokeStyle (Color.hsl (degrees 188) 0.3 0.8)
            |> fillStyle bgColor
            |> lineWidth 1.5
            |> Grid.fold2d { cols = cols, rows = rows } (drawLines model.points)
        )


drawLines : Points -> ( Int, Int ) -> Commands -> Commands
drawLines points ( x, y ) cmds =
    let
        { point } =
            Matrix.get x y points
                -- This shouldn't happen as we should always be in the matrix
                -- bounds
                |> Maybe.withDefault { point = ( 0, 0 ), random = 0 }

        ( px, py ) =
            point

        drawPoint cmds =
            if x == 0 then
                cmds
                    |> beginPath
                    |> moveTo px py
            else
                let
                    { point } =
                        Matrix.get (x + 1) y points
                            |> Maybe.withDefault { point = ( px + stepX, py ), random = 0 }

                    ( nx, ny ) =
                        point

                    ( xc, yc ) =
                        ( (px + nx) / 2
                        , (py + ny) / 2
                        )
                in
                    cmds |> quadraticCurveTo px py xc yc

        drawEol cmds =
            if x == cols - 1 then
                cmds
                    |> fill NonZero
                    |> stroke
            else
                cmds
    in
        cmds
            |> drawPoint
            |> drawEol
