module Examples.Textures exposing (main)

import Browser
import Browser.Events exposing (onAnimationFrameDelta)
import Canvas exposing (..)
import Canvas.Settings exposing (..)
import Canvas.Settings.Text exposing (..)
import Canvas.Texture as Texture exposing (Texture)
import Color exposing (Color)
import Html exposing (Html)
import Html.Attributes
import Random
import Time exposing (Posix)


type alias Flags =
    { random : Float }


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
    spriteSheetCellSize * 8


padding : number
padding =
    20


type alias Model =
    { frame : Int
    , sprites : Load Sprites
    }


type Load a
    = Loading
    | Success a
    | Failure


type alias Sprites =
    { sheet : Texture
    , floor : Texture
    , player :
        { standby : Texture
        , up : Texture
        , down : Texture
        }
    }


type Msg
    = AnimationFrame Float
    | TextureLoaded (Maybe Texture)


init : Flags -> ( Model, Cmd Msg )
init { random } =
    ( { frame = 0, sprites = Loading }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AnimationFrame _ ->
            ( { model | frame = model.frame + 1 }
            , Cmd.none
            )

        TextureLoaded Nothing ->
            ( { model | sprites = Failure }
            , Cmd.none
            )

        TextureLoaded (Just texture) ->
            ( { model
                | sprites =
                    let
                        sprite x y t =
                            Texture.sprite
                                { x = x * (spriteSheetCellSize + spriteSheetCellSpace)
                                , y = y * (spriteSheetCellSize + spriteSheetCellSpace)
                                , width = spriteSheetCellSize
                                , height = spriteSheetCellSize
                                }
                                t
                    in
                    Success
                        { sheet = texture
                        , floor = sprite 2 0 texture
                        , player =
                            { standby = sprite 23 0 texture
                            , up = sprite 24 1 texture
                            , down = sprite 27 1 texture
                            }
                        }
              }
            , Cmd.none
            )


textures : List (Texture.Source Msg)
textures =
    [ Texture.loadFromImageUrl "./assets/vector_complete.svg" TextureLoaded
    ]


numOfPlayers =
    10


spriteSheetCellSize =
    64


spriteSheetCellSpace =
    10


view : Model -> Html Msg
view model =
    Canvas.toHtmlWith
        { width = w
        , height = h
        , textures = textures
        }
        []
        (shapes [ fill Color.white ] [ rect ( 0, 0 ) w h ]
            :: (case model.sprites of
                    Loading ->
                        [ renderText "Loading sprite sheet" ]

                    Success ss ->
                        renderSprites model.frame ss

                    Failure ->
                        [ renderText "Failed to load sprite sheet!" ]
               )
        )


renderText : String -> Renderable
renderText txt =
    text
        [ font { size = 48, family = "sans-serif" }
        , align Center
        , maxWidth w
        ]
        ( w / 2, h / 2 - 24 )
        txt


renderSprites : Int -> Sprites -> List Renderable
renderSprites frame sprites =
    let
        renderPlayer i =
            let
                dimensions =
                    Texture.dimensions sprite

                sprite =
                    if abs (prevY - y) < 5 then
                        sprites.player.standby

                    else if prevY < y then
                        sprites.player.down

                    else
                        sprites.player.up

                x =
                    toFloat i * (w - toFloat spriteSheetCellSize) / numOfPlayers

                y =
                    y_ frame

                prevY =
                    y_ (frame - 1)

                y_ f =
                    sin (toFloat (f + i * 10) / 20) * (h / 4) + h / 2 - (toFloat spriteSheetCellSize / 2)
            in
            texture [] ( x, y ) sprite

        players =
            List.range 0 numOfPlayers
                |> List.map renderPlayer

        floor =
            List.range -1 (round (w / spriteSheetCellSize))
                |> List.map
                    (\i ->
                        let
                            x =
                                (i * spriteSheetCellSize - frame * 4 |> modBy (w + spriteSheetCellSize * 2)) - spriteSheetCellSize

                            y =
                                h - spriteSheetCellSize
                        in
                        texture [] ( toFloat x, y ) sprites.floor
                    )
    in
    floor ++ players
