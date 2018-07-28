module Examples.Main exposing (main)

import AnimationFrame exposing (times)
import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Encode as Encode exposing (..)
import Time exposing (Time)
import Canvas
import Color exposing (Color)


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
    = AnimationFrame Time


main : Program Never Model Msg
main =
    Html.program { init = init, update = update, subscriptions = subscriptions, view = view }


subscriptions : Model -> Sub Msg
subscriptions model =
    times AnimationFrame


init : ( Model, Cmd Msg )
init =
    ( List.range 0 1000
        |> List.map
            (\i ->
                { x = w / 2
                , y = h / 2
                , size = 2
                , speedMod = toFloat ((i * 4236) % 345)
                , deviation = toFloat ((i * 2346) % 4435)
                }
            )
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AnimationFrame time ->
            let
                normalize x =
                    (x + 1) / 2

                updatePoint point =
                    { point
                        | x =
                            (normalize (sin ((time / (300 + point.speedMod)) + point.deviation))) * (w * 0.5) + w * 0.25
                        , y =
                            (normalize (cos ((time / (500 - point.speedMod)) + point.deviation + 4543))) * (h * 0.5) + h * 0.25
                    }
            in
                ( List.map updatePoint model
                , Cmd.none
                )


h : Float
h =
    500


w : Float
w =
    500


particleColor : Color
particleColor =
    Color.rgba 0 0 0 0.1


view : Model -> Html Msg
view model =
    Canvas.element
        (round h)
        (round w)
        [ style [] ]
        (List.concat
            [ [ Canvas.clearRect 0 0 w h
              , Canvas.fillStyle particleColor
              ]
            , (List.map drawPoint model)
            ]
        )


drawPoint : Point -> Value
drawPoint { x, y, size } =
    Canvas.fillRect (x - size / 2) (y - size / 2) size size
