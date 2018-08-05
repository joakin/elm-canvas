module Examples.Template exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Time exposing (Time)
import Canvas exposing (..)
import Color exposing (Color)
import Random
import AnimationFrame as AF


main : Program Float Model Msg
main =
    Html.programWithFlags { init = init, update = update, subscriptions = subscriptions, view = view }


subscriptions : Model -> Sub Msg
subscriptions model =
    AF.diffs AnimationFrame


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
    = AnimationFrame Time


init : Float -> ( Model, Cmd Msg )
init floatSeed =
    0 ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AnimationFrame delta ->
            (model + 1) ! []


view : Model -> Html Msg
view model =
    Canvas.element
        w
        h
        [ style [] ]
        (empty
            |> clearRect 0 0 w h
            |> font "48px sans-serif"
            |> textAlign Canvas.Center
            |> fillStyle (Color.rgb 255 0 0)
            |> fillText (toString model) (w / 2) (h / 2) Nothing
        )
