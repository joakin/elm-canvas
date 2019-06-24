module Examples.Fullscreen exposing (main)

import Browser
import Browser.Dom exposing (Viewport, getViewport)
import Browser.Events exposing (onAnimationFrameDelta)
import Canvas exposing (..)
import Canvas.Settings exposing (..)
import Color
import Html exposing (Html, div)
import Html.Attributes exposing (style)
import Task


type alias Model =
    { count : Float, width : Float, height : Float }


type Msg
    = Frame Float
    | GetViewport Viewport


main : Program () Model Msg
main =
    Browser.element
        { init = \() -> ( { count = 0, width = 400, height = 400 }, Task.perform GetViewport getViewport )
        , view = view
        , update =
            \msg model ->
                case msg of
                    Frame _ ->
                        ( { model | count = model.count + 1 }, Cmd.none )

                    GetViewport data ->
                        ( { model
                            | width = data.viewport.width
                            , height = data.viewport.height
                          }
                        , Cmd.none
                        )
        , subscriptions = \model -> onAnimationFrameDelta Frame
        }


centerX width =
    width / 2


centerY height =
    height / 2


view : Model -> Html Msg
view { count, width, height } =
    div
        [ style "display" "flex"
        , style "justify-content" "center"
        , style "align-items" "center"
        ]
        [ Canvas.toHtml
            ( round width, round height )
            []
            [ clearScreen width height
            , render count width height
            ]
        ]


clearScreen width height =
    shapes [ fill Color.white ] [ rect ( 0, 0 ) width height ]


render count width height =
    let
        size =
            min width height / 3

        x =
            -(size / 2)

        y =
            -(size / 2)

        rotation =
            degrees (count * 3)

        hue =
            toFloat (count / 4 |> floor |> modBy 100) / 100
    in
    shapes
        [ transform
            [ translate (centerX width) (centerY height)
            , rotate rotation
            ]
        , fill (Color.hsl hue 0.3 0.7)
        ]
        [ rect ( x, y ) size size ]
