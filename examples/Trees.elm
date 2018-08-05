module Examples.Trees exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Time exposing (Time)
import Canvas exposing (..)
import Color exposing (Color)
import Random
import Task
import Process
import Point2d exposing (Point2d)
import LineSegment2d exposing (LineSegment2d)
import Vector2d
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


type alias Brush =
    { seed : Random.Seed
    , line : LineSegment2d
    , life : Int
    }


type alias Model =
    { brushes : List Brush
    , seed : Random.Seed
    }


type Msg
    = AnimationFrame Time


init : Float -> ( Model, Cmd Msg )
init floatSeed =
    initWithSeed (Random.initialSeed (floatSeed * 10000 |> round))


treeLocation =
    (Random.float (w * 0.2) (w * 0.8))


initWithSeed : Random.Seed -> ( Model, Cmd Msg )
initWithSeed seed =
    let
        ( randomX, seed2 ) =
            Random.step treeLocation seed

        treeStart =
            Point2d.fromCoordinates ( randomX, h )

        end =
            Point2d.fromCoordinates ( randomX, h - 5 )

        ( randomTreeSeed, seed3 ) =
            Random.step (Random.int 0 10000) seed2
                |> Tuple.mapFirst Random.initialSeed

        ( life, seed4 ) =
            Random.step (Random.int (round (h * 0.7)) h) seed3

        initialPoints =
            [ { seed = randomTreeSeed
              , line = LineSegment2d.fromEndpoints ( treeStart, end )
              , life = life
              }
            ]
    in
        ( { brushes = initialPoints
          , seed = seed4
          }
        , Cmd.none
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AnimationFrame delta ->
            if List.isEmpty model.brushes then
                initWithSeed model.seed
            else
                { model
                    | brushes = List.concatMap updateBrush model.brushes
                }
                    ! []


updateBrush brush =
    let
        { line, seed, life } =
            brush

        displacement =
            LineSegment2d.vector line
                -- Make the displacement smaller so that branches overlap
                |> Vector2d.scaleBy 0.8

        movedLine =
            LineSegment2d.translateBy displacement line

        ( children, nextSeed ) =
            split brush

        ( loseLife, nextSeed2 ) =
            Random.step (Random.int 0 10) nextSeed

        movedBrush =
            { seed = nextSeed2, line = movedLine, life = life - loseLife }
    in
        if outOfBounds movedBrush || life <= 0 then
            children
        else
            movedBrush :: children


split { line, seed, life } =
    let
        ( start, end ) =
            LineSegment2d.endpoints line

        ( p1, seed2 ) =
            Random.step (Random.float 0 1) seed

        shouldSplit =
            p1 > 0.98
    in
        if shouldSplit then
            let
                ( childSeed, seed3 ) =
                    Random.step (Random.int 0 10000) seed2
                        |> Tuple.mapFirst Random.initialSeed

                ( childSeed2, seed4 ) =
                    Random.step (Random.int 0 10000) seed3
                        |> Tuple.mapFirst Random.initialSeed

                ( degrees1, seed5 ) =
                    Random.step (Random.float -45 45) seed4

                ( degrees2, seed6 ) =
                    Random.step (Random.float -45 45) seed5
            in
                ( [ { line = LineSegment2d.rotateAround start (degrees degrees1) line
                    , life = life - 10
                    , seed = childSeed
                    }
                  , { line = LineSegment2d.rotateAround start (degrees degrees2) line
                    , life = life - 10
                    , seed = childSeed2
                    }
                  ]
                , seed6
                )
        else
            ( [], seed2 )


outOfBounds { line } =
    let
        end =
            LineSegment2d.endPoint line

        ( x, y ) =
            Point2d.coordinates end
    in
        x >= w - padding || x <= padding || y > h || y <= padding


view : Model -> Html Msg
view model =
    Canvas.element
        w
        h
        [ style [] ]
    <|
        if List.isEmpty model.brushes then
            empty
                |> fillStyle (Color.rgba 255 255 255 0.05)
                |> fillRect 0 0 w h
        else
            empty
                |> strokeStyle (Color.rgb 0 0 0)
                |> fillStyle (Color.rgba 255 255 255 0.008)
                |> fillRect 0 0 w h
                -- |> lineCap RoundCap
                |> (\cmds -> List.foldl paint cmds model.brushes)


paint { line, life } cmds =
    let
        ( start, end ) =
            LineSegment2d.endpoints line
    in
        cmds
            |> lineWidth (30 * (toFloat life) / h)
            |> beginPath
            |> moveTo (Point2d.xCoordinate start) (Point2d.yCoordinate start)
            |> lineTo (Point2d.xCoordinate end) (Point2d.yCoordinate end)
            |> stroke
