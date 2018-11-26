module Examples.Template exposing (main)

import Browser
import Browser.Events exposing (onAnimationFrameDelta)
import Canvas exposing (..)
import Color exposing (Color)
import Html exposing (Html)
import Html.Attributes
import Random
import Time exposing (Posix)


main : Program Float Model Msg
main =
    Browser.element { init = init, update = update, subscriptions = subscriptions, view = view }


subscriptions : Model -> Sub Msg
subscriptions model =
    onAnimationFrameDelta AnimationFrame


h : number
h =
    500


w : number
w =
    500


padding : number
padding =
    20


type alias Model =
    Int


type Msg
    = AnimationFrame Float


init : Float -> ( Model, Cmd Msg )
init floatSeed =
    ( 0
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AnimationFrame _ ->
            ( model + 1
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    Canvas.toHtml ( w, h )
        []
        [ shapes [ fill Color.white ] [ rect ( 0, 0 ) w h ]
        , text
            [ font { size = 48, family = "sans-serif" }
            , align Center
            , fill (Color.rgb 255 0 0)
            ]
            ( w / 2, h / 2 )
            (String.fromInt model)
        ]
