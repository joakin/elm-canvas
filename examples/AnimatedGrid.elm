module Examples.AnimatedGrid exposing (main)

{-
   Adaptation from @mattdesl's gist
   https://gist.github.com/mattdesl/cb27d1285d4ceaa091094bad92ebd7fb
-}

import AnimationFrame exposing (times)
import Html exposing (Html)
import Html.Events exposing (onClick)
import Time exposing (Time)
import Canvas exposing (..)
import Color exposing (Color)
import Grid


type alias Model =
    ( Bool, Float )


type Msg
    = AnimationFrame Time
    | ToggleRunning


main : Program Never Model Msg
main =
    Html.program { init = init, update = update, subscriptions = subscriptions, view = view }


subscriptions : Model -> Sub Msg
subscriptions ( isRunning, time ) =
    if isRunning then
        times AnimationFrame
    else
        Sub.none


init : ( Model, Cmd Msg )
init =
    ( ( True, 0 * Time.millisecond )
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ( isRunning, time ) =
    case msg of
        AnimationFrame time ->
            ( ( isRunning, Time.inMilliseconds time ), Cmd.none )

        ToggleRunning ->
            ( ( not isRunning, time ), Cmd.none )


h : Float
h =
    500


w : Float
w =
    500


gridSize =
    24


gridSizef =
    toFloat gridSize


cellSize =
    (w - padding * 2) / gridSizef


padding =
    w * 0.1


length =
    cellSize * 0.65


thickness =
    cellSize * 0.1


view : Model -> Html Msg
view ( isRunning, time ) =
    element
        (round w)
        (round h)
        [ onClick ToggleRunning ]
        (empty
            |> clearScreen
            |> fillStyle (Color.rgba 0 0 0 1)
            |> renderItems time
        )


clearScreen cmds =
    cmds
        |> clearRect 0 0 w h
        |> fillStyle (Color.rgb 255 255 255)
        |> fillRect 0 0 w h


renderItems time cmds =
    Grid.fold2d { rows = gridSize, cols = gridSize }
        (renderItem time)
        cmds


renderItem time ( col, row ) cmds =
    let
        ( colf, rowf ) =
            ( toFloat col, toFloat row )

        ( x, y ) =
            ( (rowf * cellSize) + padding + cellSize / 2
            , (colf * cellSize) + padding + cellSize / 2
            )

        ( u, v ) =
            ( colf / (gridSizef - 1)
            , rowf / (gridSizef - 1)
            )

        offset =
            u * 0.4 + v * 0.2

        t =
            time / 1000

        rotationModifier =
            (sin (t + offset)) ^ 3

        initialRotation =
            degrees 90

        rotation =
            initialRotation + rotationModifier * pi
    in
        cmds
            |> save
            |> fillStyle (Color.rgb 0 0 0)
            |> translate x y
            |> rotate rotation
            |> translate -x -y
            |> fillRect (x - length / 2) (y - thickness / 2) length thickness
            |> restore


lerp : Float -> Float -> Float -> Float
lerp v0 v1 t =
    v0 * (1 - t) + v1 * t
