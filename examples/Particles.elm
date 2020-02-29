module Particles exposing (main)

import Browser
import Browser.Events exposing (onAnimationFrame)
import Canvas exposing (..)
import Canvas.Settings exposing (..)
import Color exposing (Color)
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
    Color.rgba 0 0 0 0.3


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
                , size = toFloat (modBy 2 i + 1)
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
    Canvas.toHtml
        ( round w, round h )
        []
        [ shapes [ fill Color.white ] [ rect ( 0, 0 ) w h ]
        , shapes [ fill particleColor ] (List.map drawPoint model)
        ]


drawPoint : Point -> Shape
drawPoint { x, y, size } =
    circle ( x, y ) size
