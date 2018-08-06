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
    50


step =
    13


cols =
    (w - padding * 2) // step


rows =
    (h - padding * 2) // step


cells =
    (rows * cols)


type alias Model =
    { count : Int
    , points : Matrix { point : ( Float, Float ), random : Float }
    }


type Msg
    = AnimationFrame Time


isFirstPoint ( x, y ) =
    x == step / 2 + padding


coordsToPx ( x, y ) =
    ( x * step + step / 2 + padding
    , y * step + step / 2 + padding * 1.5
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


view : Model -> Html Msg
view model =
    Canvas.element
        w
        h
        [ style [] ]
        (empty
            |> clearRect 0 0 w h
            |> strokeStyle (Color.hsl 0 0.05 0.2)
            |> fillStyle (Color.rgb 255 255 255)
            |> lineWidth 2
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
                                            ( (px + (px + step)) / 2, py )
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
