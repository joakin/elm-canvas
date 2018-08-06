module Examples.JoyDivision exposing (main)

import Html exposing (..)
import Html.Attributes exposing (style)
import Time exposing (Time)
import Canvas exposing (..)
import Color exposing (Color)
import Random
import AnimationFrame as AF
import Matrix exposing (Matrix)


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


type alias Model =
    { count : Int
    , points : Matrix { point : ( Float, Float ), random : Float }
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
            |> drawLines 0 0 model.points
        )


drawLines x y points cmds =
    if x >= cols then
        drawLines 0 (y + 1) points cmds
    else if y >= rows then
        cmds
    else
        case Matrix.get x y points of
            Just { point } ->
                let
                    ( px, py ) =
                        point

                    cmds1 =
                        if x == 0 then
                            cmds
                                |> beginPath
                                |> moveTo px py
                        else
                            let
                                ( xc, yc ) =
                                    case Matrix.get (x + 1) y points of
                                        Just { point } ->
                                            let
                                                ( nx, ny ) =
                                                    point
                                            in
                                                ( (px + nx) / 2
                                                , (py + ny) / 2
                                                )

                                        Nothing ->
                                            ( (px + (px + stepX)) / 2, py )
                            in
                                cmds
                                    |> quadraticCurveTo px py xc yc

                    cmds2 =
                        if x == cols - 1 then
                            cmds1
                                |> fill NonZero
                                |> stroke
                        else
                            cmds1
                in
                    drawLines (x + 1) y points cmds2

            Nothing ->
                let
                    _ =
                        Debug.log "Couldn't get index" ( x, y )
                in
                    cmds
