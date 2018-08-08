module Examples.Drawing exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Time exposing (Time)
import Canvas exposing (..)
import Color exposing (Color)
import Random
import AnimationFrame as AF
import Mouse
import Touch
import Json.Decode as Decode


main : Program Float Model Msg
main =
    Html.programWithFlags { init = init, update = update, subscriptions = subscriptions, view = view }


subscriptions : Model -> Sub Msg
subscriptions model =
    -- Sub.none
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


type Drawing
    = StartLine ( Float, Float )
    | LineTo ( Float, Float )
    | EndLine ( Float, Float )


type alias Model =
    { frames : Int
    , drawing : List Drawing
    , isDrawing : Bool
    , color : Color
    }


type Msg
    = AnimationFrame Time
    | StartAt ( Float, Float )
    | MoveAt ( Float, Float )
    | EndAt ( Float, Float )
    | SelectColor Color


init : Float -> ( Model, Cmd Msg )
init floatSeed =
    { frames = 0, drawing = [], isDrawing = False, color = Color.lightBlue }
        ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ frames, drawing, isDrawing } as model) =
    (case msg of
        AnimationFrame delta ->
            { model
                | frames = (frames + 1)
                , drawing =
                    {-
                       Just rendered, clear up the drawing pipeline as needed
                       - If nothing was drawn, nothing to do
                       - If we started a line, we can keep it, no effect
                       - If we moved to somewhere, lets end the line to render
                         progress while drawing, and re-start it in the same
                         place so that followup moves are captured
                       - If we just ended a line, clear the queue up
                    -}
                    case List.head drawing of
                        Nothing ->
                            []

                        Just (StartLine _) ->
                            drawing

                        Just (LineTo pos) ->
                            StartLine pos :: EndLine pos :: []

                        Just (EndLine _) ->
                            []
            }

        StartAt point ->
            model
                |> currentlyDrawing True
                |> addDrawingPoint (StartLine point)

        MoveAt point ->
            addDrawingPoint (LineTo point) model

        EndAt point ->
            model
                |> addDrawingPoint (EndLine point)
                |> currentlyDrawing False

        SelectColor color ->
            { model | color = color }
    )
        ! []


currentlyDrawing isDrawing model =
    { model | isDrawing = isDrawing }


addDrawingPoint point ({ drawing, isDrawing } as model) =
    if isDrawing then
        { model | drawing = point :: drawing }
    else
        model


getShadowColor color =
    let
        { red, green, blue } =
            Color.toRgb color
    in
        Color.rgba red green blue 0.1


view : Model -> Html Msg
view model =
    div []
        [ p [ style [ ( "text-align", "center" ), ( "font-size", "80%" ) ] ] [ text "Draw something with the mouse!" ]
        , Canvas.element
            w
            h
            [ style [ ( "touch-action", "none" ) ]
            , Mouse.onDown (.offsetPos >> StartAt)
            , Mouse.onMove (.offsetPos >> MoveAt)
            , Mouse.onUp (.offsetPos >> EndAt)
            , Mouse.onLeave (.offsetPos >> EndAt)
            , Mouse.onContextMenu (.offsetPos >> EndAt)
            , onTouch "touchstart" (touchCoordinates >> StartAt)
            , onTouch "touchmove" (touchCoordinates >> MoveAt)
            , onTouch "touchend" (touchCoordinates >> EndAt)
            ]
            (empty
                |> shadowColor (getShadowColor model.color)
                |> shadowBlur 10
                |> lineWidth 15
                |> lineCap RoundCap
                |> strokeStyle model.color
                |> drawLines (List.reverse model.drawing)
            )
        , div
            [ style
                [ ( "max-width", toString (w - 20) ++ "px" )
                , ( "padding", "10px" )
                ]
            ]
            [ colorButtons ]
        ]


drawLines drawings cmds =
    case drawings of
        [] ->
            cmds

        drawing :: rest ->
            (case drawing of
                StartLine ( x, y ) ->
                    cmds
                        |> beginPath
                        |> moveTo x y

                LineTo ( x, y ) ->
                    cmds
                        |> lineTo x y

                EndLine ( x, y ) ->
                    cmds
                        |> lineTo x y
                        |> stroke
            )
                |> drawLines rest


colorButtons =
    div
        [ style
            [ ( "display", "flex" )
            , ( "flex-direction", "row" )
            , ( "justify-content", "space-around" )
            ]
        ]
        [ col
            [ colorButton (Color.lightRed)
            , colorButton (Color.red)
            , colorButton (Color.darkRed)
            ]
        , col
            [ colorButton (Color.lightOrange)
            , colorButton (Color.orange)
            , colorButton (Color.darkOrange)
            ]
        , col
            [ colorButton (Color.lightYellow)
            , colorButton (Color.yellow)
            , colorButton (Color.darkYellow)
            ]
        , col
            [ colorButton (Color.lightGreen)
            , colorButton (Color.green)
            , colorButton (Color.darkGreen)
            ]
        , col
            [ colorButton (Color.lightBlue)
            , colorButton (Color.blue)
            , colorButton (Color.darkBlue)
            ]
        , col
            [ colorButton (Color.lightPurple)
            , colorButton (Color.purple)
            , colorButton (Color.darkPurple)
            ]
        , col
            [ colorButton (Color.lightBrown)
            , colorButton (Color.brown)
            , colorButton (Color.darkBrown)
            ]
        , col
            [ colorButton (Color.white)
            , colorButton (Color.lightGrey)
            , colorButton (Color.grey)
            ]
        , col
            [ colorButton (Color.darkGrey)
            , colorButton (Color.lightCharcoal)
            , colorButton (Color.charcoal)
            ]
        , col
            [ colorButton (Color.darkCharcoal)
            , colorButton (Color.black)
            ]
        ]


col btns =
    div [] btns


colorButton color =
    button
        [ style
            [ ( "border-radius", "50%" )
            , ( "background-color", colorToCSSString color )
            , ( "display", "block" )
            , ( "width", "40px" )
            , ( "height", "40px" )
            , ( "margin", "5px" )
            , ( "border", "2px solid white" )
            ]
        , onClick (SelectColor color)
        ]
        []


colorToCSSString : Color -> String
colorToCSSString color =
    let
        { red, green, blue, alpha } =
            Color.toRgb color
    in
        "rgba("
            ++ (toString red)
            ++ ", "
            ++ (toString green)
            ++ ", "
            ++ (toString blue)
            ++ ", "
            ++ (toString alpha)
            ++ ")"


touchCoordinates : { event : Touch.Event, targetOffset : ( Float, Float ) } -> ( Float, Float )
touchCoordinates { event, targetOffset } =
    List.head event.changedTouches
        |> Maybe.map
            (\touch ->
                let
                    ( x, y ) =
                        touch.pagePos

                    ( x2, y2 ) =
                        targetOffset
                in
                    -- log "touch + targetOffset"
                    --     ( touch, targetOffset )
                    ( x - x2, y - y2 )
            )
        |> Maybe.withDefault ( 0, 0 )


onTouch event tag =
    Decode.map tag eventDecoder
        |> Html.Events.onWithOptions event
            { preventDefault = True
            , stopPropagation = True
            }


eventDecoder =
    Decode.map2
        (\event offset ->
            { event = event
            , targetOffset = offset
            }
        )
        Touch.eventDecoder
        offsetDecoder


offsetDecoder =
    (Decode.field "target"
        (Decode.map2 (\top left -> ( left, top ))
            (Decode.field "offsetTop" Decode.float)
            (Decode.field "offsetLeft" Decode.float)
        )
    )


log msg thingToLog thingToReturn =
    Debug.log msg thingToLog
        |> (\_ -> thingToReturn)
