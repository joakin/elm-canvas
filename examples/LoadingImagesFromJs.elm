module LoadingImagesFromJs exposing (main)

import Browser
import Browser.Events exposing (onAnimationFrameDelta)
import Canvas exposing (..)
import Canvas.Settings exposing (..)
import Canvas.Settings.Advanced exposing (..)
import Canvas.Texture exposing (..)
import Color exposing (Color)
import Html exposing (Html)
import Html.Attributes
import Json.Decode as D
import Random
import Time exposing (Posix)


type alias Flags =
    List D.Value


main : Program Flags Model Msg
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
    ( Float, List Texture )


type Msg
    = AnimationFrame Float


init : Flags -> ( Model, Cmd Msg )
init images =
    let
        textures =
            images
                |> List.filterMap (Result.toMaybe << fromCanvasImageSource)
    in
    ( ( 0, textures )
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ( count, textures ) =
    case msg of
        AnimationFrame delta ->
            ( ( count + delta / 10, textures )
            , Cmd.none
            )


view : Model -> Html Msg
view ( count, textures ) =
    let
        total =
            List.length textures |> toFloat

        maxSize =
            tw / total

        tw =
            w - padding * 2

        th =
            h - padding * 2 - maxSize
    in
    Canvas.toHtml ( w, h )
        []
        (shapes [ fill Color.white ] [ rect ( 0, 0 ) w h ]
            :: List.indexedMap
                (\i t ->
                    let
                        d =
                            dimensions t

                        ( ratio, smoothing ) =
                            if i == round total - 1 then
                                ( 7.5, False )

                            else
                                ( maxSize / max d.width d.height, True )

                        ( x, y ) =
                            ( padding + (tw / total) * toFloat i
                            , padding + sin ((count + toFloat i * 6) / 40) * (th / 2) + th / 2
                            )
                    in
                    texture
                        [ transform [ translate x y, scale ratio ratio ]
                        , imageSmoothing smoothing
                        ]
                        ( 0, 0 )
                        t
                )
                textures
        )
