module Examples.CirclePacking exposing (main)

{-| Based on the tutorial at <https://generativeartistry.com/tutorials/circle-packing/>

1.  Create a new Circle
2.  Check to see if the circle collides with any other circles we have.
3.  If it doesn’t collide, we will grow it slightly, and then check again if it collides.
4.  Repeat these steps until we have a collision, or we reach a “max size”
5.  Create another circle and repeat x times.

-}

import Browser
import Canvas exposing (..)
import Canvas.Color as Color exposing (Color)
import Circle2d exposing (Circle2d)
import Html exposing (..)
import Html.Attributes exposing (..)
import Point2d exposing (Point2d)
import Process
import Random
import Task
import Time exposing (Posix)


main : Program () Model Msg
main =
    Browser.element { init = init, update = update, subscriptions = subscriptions, view = view }


subscriptions : Model -> Sub Msg
subscriptions model =
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


init : () -> ( Model, Cmd Msg )
init _ =
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
                        grownCircle =
                            grow circle

                        collides =
                            collidesWithAny grownCircle circles

                        tooBig =
                            Circle2d.radius grownCircle > maxRadius
                    in
                    if collides || tooBig then
                        ( model, tryNewCircle )

                    else
                        ( { model | circles = grownCircle :: circles }, growCircle )

        TryNewCircle _ ->
            ( model, Random.generate NewCircle randomCircle )


growCircle : Cmd Msg
growCircle =
    -- <| Process.sleep (0 * Time.millisecond)
    -- <| Task.succeed ()
    Task.perform GrowCircle <| Process.sleep 4


tryNewCircle : Cmd Msg
tryNewCircle =
    --(Process.sleep (0 * Time.millisecond))
    Task.perform TryNewCircle <| Task.succeed ()


grow : Circle2d -> Circle2d
grow circle =
    Circle2d.withRadius (Circle2d.radius circle + 1)
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
    Canvas.toHtml ( w, h )
        []
        [ shapes [ rect ( 0, 0 ) w h ] |> fill Color.white
        , List.map viewCircle model.circles
            |> shapes
            |> lineWidth 2
            |> fill (Color.rgba 0 0 0 0.1)
            |> stroke (Color.rgb 0 0 0)
        ]


viewCircle : Circle2d -> Shape
viewCircle c =
    let
        center =
            Circle2d.centerPoint c

        ( x, y ) =
            Point2d.coordinates center
    in
    circle ( x, y ) (Circle2d.radius c)
