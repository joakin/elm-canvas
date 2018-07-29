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


gridSize : Float
gridSize =
    24


cellSize : Float
cellSize =
    (w - padding * 2) / gridSize


padding : Float
padding =
    w * 0.1


clearScreen : Command
clearScreen =
    batch
        [ clearRect 0 0 w h
        , fillStyle (Color.rgb 255 255 255)
        , fillRect 0 0 w h
        ]


view : Model -> Html Msg
view ( isRunning, time ) =
    element
        (round h)
        (round w)
        [ onClick ToggleRunning ]
        [ clearScreen
        , fillStyle (Color.rgba 0 0 0 1)
        , List.range 0 (floor (gridSize * gridSize) - 1)
            |> List.map (renderItem time)
            |> batch
        ]


renderItem : Float -> Int -> Command
renderItem time i =
    let
        col =
            toFloat (i % (floor gridSize))

        row =
            toFloat (i // (floor gridSize))

        x =
            (row * cellSize)
                |> (+) (padding + cellSize / 2)

        y =
            (col * cellSize)
                |> (+) (padding + cellSize / 2)

        u =
            col / (gridSize - 1)

        v =
            row / (gridSize - 1)

        offset =
            u * 0.4 + v * 0.2

        t =
            time
                / 1000

        mod =
            (sin (t + offset)) ^ 3

        initialRotation =
            degrees 90

        rotation =
            initialRotation + mod * pi

        length =
            cellSize * 0.65

        thickness =
            cellSize * 0.1
    in
        batch
            [ save
            , fillStyle (Color.rgb 0 0 0)
            , translate x y
            , rotate rotation
            , translate -x -y
            , fillRect (x - length / 2) (y - thickness / 2) length thickness
            , restore
            ]


lerp : Float -> Float -> Float -> Float
lerp v0 v1 t =
    v0 * (1 - t) + v1 * t
