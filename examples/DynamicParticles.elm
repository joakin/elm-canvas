module Examples.DynamicParticles exposing (main)

{-
   Adapted from:
   * https://discourse.elm-lang.org/t/need-help-with-performance-dynamic-particles/1570
   * https://ellie-app.com/T9NxzWvnd7a1
-}

import Browser
import Browser.Events exposing (onAnimationFrame)
import Canvas exposing (..)
import Canvas.Settings exposing (..)
import Color exposing (Color)
import Html exposing (Html)
import Html.Attributes as Attributes
import Json.Decode as Decode exposing (Decoder, Value)
import Random exposing (Generator)
import Random.Extra
import Random.List
import Time exposing (Posix)


type alias Canvas =
    { width : Int
    , height : Int
    }


type alias Particle =
    { origin : ( Float, Float )
    , cx : Float
    , cy : Float
    , vx : Float
    , vy : Float
    , r : Float
    , rMax : Float
    , friction : Float
    , gravity : Float
    , color : Color
    , dying : Bool
    , duration : Float
    }


generateRadius : Particle -> Generator Float
generateRadius { r } =
    Random.float r (r + 3)


generateHeading : Generator Float
generateHeading =
    Random.float (degrees 0) (degrees 360)


generateColor : Generator Color
generateColor =
    Random.List.choose
        [ Color.rgb255 0 48 73
        , Color.rgb255 73 214 40
        , Color.rgb255 247 127 0
        , Color.rgb255 252 191 73
        , Color.rgb255 234 226 183
        ]
        |> Random.map Tuple.first
        |> Random.map (Maybe.withDefault (Color.rgb255 252 191 73))


generateParticle : Particle -> Generator Particle
generateParticle particle =
    Random.map3
        (\newR heading newColor -> setHeading heading { particle | rMax = newR, color = newColor })
        (generateRadius particle)
        generateHeading
        generateColor


getSpeed : Particle -> Float
getSpeed { vx, vy } =
    sqrt (vx * vx + vy * vy)


setHeading : Float -> Particle -> Particle
setHeading heading particle =
    let
        speed =
            getSpeed particle
    in
    { particle
        | vx = cos heading * speed
        , vy = sin heading * speed
    }


isOffCanvas : Canvas -> Particle -> Bool
isOffCanvas { height } { cy } =
    (cy < 0) || (cy > toFloat height)


isDead : Particle -> Bool
isDead { r } =
    r < 1


isGrowing : Particle -> Bool
isGrowing { r, rMax } =
    r < rMax



-- MODEL --


type Model
    = Init Canvas
    | Go
        { canvas : Canvas
        , particles : List Particle
        }


init : Value -> ( Model, Cmd Msg )
init json =
    let
        ( size, points ) =
            case Decode.decodeValue flagDecoder json of
                Ok result ->
                    result

                Err _ ->
                    ( ( 0, 0 ), [] )

        canvas =
            { width = Tuple.first size, height = Tuple.second size }
    in
    ( Init canvas
    , points
        |> List.map pointToParticle
        |> List.map (updateParticle True canvas)
        |> Random.Extra.combine
        |> Random.generate Generated
    )


flagDecoder : Decoder ( ( Int, Int ), List Point )
flagDecoder =
    Decode.map2 (\a b -> ( a, b ))
        (Decode.at [ "size" ] sizeDecoder)
        (Decode.at [ "points" ] (Decode.list pointDecoder))


sizeDecoder : Decoder ( Int, Int )
sizeDecoder =
    Decode.map2 (\a b -> ( a, b ))
        (Decode.at [ "width" ] Decode.int)
        (Decode.at [ "height" ] Decode.int)


pointDecoder : Decoder Point
pointDecoder =
    Decode.list Decode.int
        |> Decode.andThen
            (\list ->
                case list of
                    [ x, y ] ->
                        Decode.succeed ( x, y )

                    _ ->
                        Decode.fail "Did not recieve a pair"
            )


type alias Point =
    ( Int, Int )


pointToParticle : Point -> Particle
pointToParticle ( cx, cy ) =
    { origin = ( toFloat cx, toFloat cy )
    , cx = toFloat cx
    , cy = toFloat cy
    , vx = 0
    , vy = 0
    , r = 2
    , rMax = 5
    , friction = 0.99
    , gravity = 0
    , color = Color.blue
    , dying = False
    , duration = 0.2
    }



-- VIEW --


view : Model -> Html Msg
view model =
    case model of
        Init _ ->
            Html.text ""

        Go { canvas, particles } ->
            Canvas.toHtml ( canvas.width, canvas.height )
                []
                (shapes [ fill Color.white ] [ rect ( 0, 0 ) (toFloat canvas.width) (toFloat canvas.height) ]
                    :: List.map viewParticle particles
                )


viewParticle : Particle -> Renderable
viewParticle { cx, cy, r, color } =
    shapes [ fill color ] [ circle ( cx, cy ) r ]



-- UPDATE --


type Msg
    = Tick Posix
    | Generated (List Particle)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick _ ->
            case model of
                Init _ ->
                    ( model, Cmd.none )

                Go { canvas, particles } ->
                    ( model
                    , Random.generate
                        Generated
                        (particles
                            |> List.map (updateParticle False canvas)
                            |> Random.Extra.combine
                        )
                    )

        Generated particles ->
            case model of
                Init canvas ->
                    ( Go { canvas = canvas, particles = particles }, Cmd.none )

                Go { canvas } ->
                    ( Go { canvas = canvas, particles = particles }, Cmd.none )


updateParticle : Bool -> Canvas -> Particle -> Generator Particle
updateParticle isInit canvas particle =
    if isInit then
        generateParticle
            { particle
                | cx = Tuple.first particle.origin
                , cy = Tuple.second particle.origin
                , vx = particle.vx
                , vy = particle.vy
                , r = 2
                , dying = False
            }

    else
        particle
            |> updateHealth
            |> updatePosition canvas


updatePosition : Canvas -> Particle -> Generator Particle
updatePosition canvas particle =
    if isOffCanvas canvas particle || isDead particle then
        generateParticle
            { particle
                | cx = Tuple.first particle.origin
                , cy = Tuple.second particle.origin
                , vx = particle.vx
                , vy = particle.vy
                , r = 2
                , dying = False
            }

    else
        Random.constant
            { particle
                | cx = particle.cx + particle.vx
                , cy = particle.cy + particle.vy
                , vx = particle.vx * particle.friction
                , vy = particle.vy * particle.friction
            }


updateHealth : Particle -> Particle
updateHealth particle =
    if isGrowing particle && not particle.dying then
        { particle
            | r = particle.r + particle.duration
        }

    else
        { particle
            | r = particle.r - particle.duration
            , dying = True
        }


main : Program Value Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> onAnimationFrame Tick
        }
