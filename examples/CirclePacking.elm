module Examples.CirclePacking exposing (main)

{-| Based on the tutorial at <https://generativeartistry.com/tutorials/circle-packing/>

1.  Create a new Circle
2.  Check to see if the circle collides with any other circles we have.
3.  If it doesn’t collide, we will grow it slightly, and then check again if it collides.
4.  Repeat these steps until we have a collision, or we reach a “max size”
5.  Create another circle and repeat x times.

-}

import Html exposing (..)
import Html.Attributes exposing (..)
import Time exposing (Time)
import Canvas
import Color exposing (Color)
import Circle2d exposing (Circle2d)
import Point2d exposing (Point2d)
import Random
import Task
import Process


main : Program Never Model Msg
main =
    Html.program { init = init, update = update, subscriptions = subscriptions, view = view }


subscriptions : Model -> Sub Msg
subscriptions model =
    -- times AnimationFrame
    Sub.none


h : number
h =
    500


w : number
w =
    500


padding : number
padding =
    20


minRadius : number
minRadius =
    2


maxRadius : number
maxRadius =
    100


totalCircles : number
totalCircles =
    500


createCircleAttempts : number
createCircleAttempts =
    500


type alias Model =
    { circles : List Circle2d
    , attempts : Int
    }


type Msg
    = NewCircle Circle2d
    | TryNewCircle ()
    | GrowCircle ()


randomCoord : Float -> Random.Generator Float
randomCoord max =
    Random.float 0 max


randomPosition : Random.Generator ( Float, Float )
randomPosition =
    Random.pair (randomCoord (w - (padding * 2))) (randomCoord (h - (padding * 2)))
        |> Random.map (\( x, y ) -> ( x + padding, y + padding ))


randomCircle : Random.Generator Circle2d
randomCircle =
    Random.map newCircle randomPosition


newCircle : ( Float, Float ) -> Circle2d
newCircle pos =
    Circle2d.withRadius minRadius
        (Point2d.fromCoordinates pos)


init : ( Model, Cmd Msg )
init =
    ( { circles = [], attempts = 0 }
    , Random.generate NewCircle randomCircle
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewCircle circle ->
            if collidesWithAny circle model.circles then
                if model.attempts == createCircleAttempts then
                    ( model, Cmd.none )
                else
                    ( { model | attempts = model.attempts + 1 }
                    , tryNewCircle
                    )
            else
                ( { model | circles = circle :: model.circles, attempts = 0 }
                , growCircle
                )

        GrowCircle _ ->
            case model.circles of
                [] ->
                    ( model, Cmd.none )

                circle :: circles ->
                    let
                        newCircle =
                            grow circle

                        collides =
                            collidesWithAny newCircle circles

                        tooBig =
                            (Circle2d.radius newCircle) > maxRadius
                    in
                        if collides || tooBig then
                            ( model, tryNewCircle )
                        else
                            ( { model | circles = newCircle :: circles }, growCircle )

        TryNewCircle _ ->
            ( model, Random.generate NewCircle randomCircle )


growCircle : Cmd Msg
growCircle =
    -- <| Process.sleep (0 * Time.millisecond)
    -- <| Task.succeed ()
    Task.perform GrowCircle <| Process.sleep (4 * Time.millisecond)


tryNewCircle : Cmd Msg
tryNewCircle =
    --(Process.sleep (0 * Time.millisecond))
    Task.perform TryNewCircle <| Task.succeed ()


grow : Circle2d -> Circle2d
grow circle =
    Circle2d.withRadius ((Circle2d.radius circle) + 1)
        (Circle2d.centerPoint circle)


collidesWithAny : Circle2d -> List Circle2d -> Bool
collidesWithAny circle circles =
    let
        r1 =
            Circle2d.radius circle

        ( x1, y1 ) =
            circle |> Circle2d.centerPoint |> Point2d.coordinates
    in
        case circles of
            [] ->
                if x1 + r1 >= w - padding || x1 - r1 <= padding then
                    True
                else if y1 + r1 >= h - padding || y1 - r1 <= padding then
                    True
                else
                    False

            head :: rest ->
                let
                    r2 =
                        Circle2d.radius head

                    a =
                        r1 + r2

                    ( x2, y2 ) =
                        head |> Circle2d.centerPoint |> Point2d.coordinates

                    ( x, y ) =
                        ( x1 - x2, y1 - y2 )

                    collides =
                        a >= sqrt ((x * x) + (y * y))
                in
                    if collides then
                        True
                    else
                        collidesWithAny circle rest


view : Model -> Html Msg
view model =
    Canvas.element
        w
        h
        [ style [] ]
        (Canvas.empty
            |> Canvas.clearRect 0 0 w h
            |> Canvas.lineWidth 2
            |> Canvas.fillStyle (Color.rgba 0 0 0 0.1)
            |> Canvas.strokeStyle (Color.rgb 0 0 0)
            |> (\cmds -> List.foldl viewCircle cmds model.circles)
        )


viewCircle : Circle2d -> Canvas.Commands -> Canvas.Commands
viewCircle circle cmds =
    let
        center =
            Circle2d.centerPoint circle

        ( x, y ) =
            Point2d.coordinates center
    in
        cmds
            |> Canvas.fillCircle x y (Circle2d.radius circle)
            |> Canvas.stroke
