module Examples.Particles exposing (main)

import Browser
import Browser.Events exposing (onAnimationFrame)
import Canvas
import CanvasColor as Color exposing (Color)
import Html exposing (..)
import Html.Attributes exposing (..)
import Time exposing (Posix)


type alias Point =
    { x : Float
    , y : Float
    , size : Float
    , deviation : Float
    , speedMod : Float
    }


type alias Model =
    List Point


type Msg
    = AnimationFrame Posix


main : Program () Model Msg
main =
    Browser.element { init = init, update = update, subscriptions = subscriptions, view = view }


subscriptions : Model -> Sub Msg
subscriptions model =
    onAnimationFrame AnimationFrame


h : Float
h =
    500


w : Float
w =
    500


padding : Float
padding =
    w / 6


cellW : Float
cellW =
    w - (padding * 2)


cellH : Float
cellH =
    h - (padding * 2)


particleColor : Color
particleColor =
    Color.rgba 0 0 0 0.1


numParticles : Int
numParticles =
    1000


init : () -> ( Model, Cmd Msg )
init () =
    ( List.range 0 numParticles
        |> List.map
            (\i ->
                { x = w / 2
                , y = h / 2
                , size = 3
                , speedMod = toFloat (modBy 345 (i * 4236))
                , deviation = toFloat (modBy 4435 (i * 2346))
                }
            )
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AnimationFrame time ->
            let
                timef =
                    time |> Time.posixToMillis |> toFloat

                normalize x =
                    (x + 1) / 2

                updatePoint point =
                    { point
                        | x =
                            normalize (sin ((timef / (300 + point.speedMod)) + point.deviation))
                                * cellW
                                + padding
                        , y =
                            normalize (cos ((timef / (500 - point.speedMod)) + point.deviation + 4543))
                                * cellH
                                + padding
                    }
            in
            ( List.map updatePoint model
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    Canvas.element
        (round w)
        (round h)
        []
        (Canvas.empty
            |> Canvas.clearRect 0 0 w h
            |> Canvas.fillStyle particleColor
            |> (\cmds -> List.foldl drawPoint cmds model)
        )


drawPoint : Point -> Canvas.Commands -> Canvas.Commands
drawPoint { x, y, size } cmds =
    cmds
        |> Canvas.fillCircle (x - size / 2) (y - size / 2) (size / 2)
