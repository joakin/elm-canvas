module Examples.Drawing exposing (main)

import Browser
import Browser.Events exposing (onAnimationFrameDelta)
import Canvas exposing (..)
import CanvasColor as Color exposing (Color)
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Html.Events.Extra.Mouse as Mouse
import Html.Events.Extra.Touch as Touch
import Json.Decode as Decode
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


type alias Point =
    { x : Float, y : Float }


type alias DrawingPointer =
    { previousMidpoint : Point, lastPoint : Point }


type alias Model =
    { frames : Int
    , pending : Commands
    , toDraw : Commands
    , drawingPointer : Maybe DrawingPointer
    , color : Color
    , size : Int
    }


type Msg
    = AnimationFrame Float
    | StartAt ( Float, Float )
    | MoveAt ( Float, Float )
    | EndAt ( Float, Float )
    | SelectColor Color
    | SelectSize Int


init : Float -> ( Model, Cmd Msg )
init floatSeed =
    ( { frames = 0
      , pending =
            Canvas.empty
                |> shadowBlur 10
                |> lineCap RoundCap
                |> lineJoin RoundJoin
      , toDraw = Canvas.empty
      , drawingPointer = Nothing
      , color = Color.lightBlue
      , size = 20
      }
        |> selectColor Color.lightBlue
        |> selectSize 20
        |> flushPendingToDraw
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ frames, drawingPointer, pending, toDraw } as model) =
    ( case msg of
        AnimationFrame delta ->
            model
                |> incFrames
                |> flushPendingToDraw

        StartAt point ->
            initialPoint point model

        MoveAt point ->
            case drawingPointer of
                Just pointer ->
                    drawPoint point pointer model

                Nothing ->
                    model

        EndAt point ->
            case drawingPointer of
                Just pointer ->
                    finalPoint point pointer model

                Nothing ->
                    model

        SelectColor color ->
            selectColor color model

        SelectSize size ->
            selectSize size model
    , Cmd.none
    )


incFrames ({ frames } as model) =
    { model | frames = frames + 1 }


flushPendingToDraw ({ pending } as model) =
    { model
        | pending = Canvas.empty
        , toDraw = pending
    }


selectColor color ({ pending } as model) =
    { model
        | color = color
        , pending =
            pending
                |> shadowColor (getShadowColor color)
                |> strokeStyle color
    }


selectSize size ({ pending } as model) =
    { model
        | size = size
        , pending =
            pending
                |> lineWidth (toFloat size)
    }


initialPoint (( x, y ) as point) model =
    { model
        | drawingPointer = Just { previousMidpoint = Point x y, lastPoint = Point x y }
    }


drawPoint ( x, y ) { previousMidpoint, lastPoint } ({ pending } as model) =
    let
        newPoint =
            Point x y

        newMidPoint =
            controlPoint lastPoint newPoint
    in
    { model
        | drawingPointer = Just { previousMidpoint = newMidPoint, lastPoint = newPoint }
        , pending =
            pending
                |> beginPath
                |> moveTo previousMidpoint.x previousMidpoint.y
                |> quadraticCurveTo lastPoint.x lastPoint.y newMidPoint.x newMidPoint.y
                |> stroke
    }


finalPoint ( x, y ) { previousMidpoint, lastPoint } ({ pending } as model) =
    { model
        | drawingPointer = Nothing
        , pending =
            pending
                |> beginPath
                |> moveTo previousMidpoint.x previousMidpoint.y
                |> quadraticCurveTo lastPoint.x lastPoint.y x y
                |> stroke
    }


controlPoint p1 p2 =
    { x = p1.x + (p2.x - p1.x) / 2
    , y = p1.y + (p2.y - p1.y) / 2
    }


getShadowColor color =
    let
        { red, green, blue } =
            Color.toRgb color
    in
    Color.rgba red green blue 0.2


view : Model -> Html Msg
view { color, size, toDraw } =
    div []
        [ p [ style "text-align" "center", style "font-size" "80%" ]
            [ text "Draw something! (mouse or touch)"
            ]
        , Canvas.element
            w
            h
            [ style "touch-action" "none"
            , Mouse.onDown (.offsetPos >> StartAt)
            , Mouse.onMove (.offsetPos >> MoveAt)
            , Mouse.onUp (.offsetPos >> EndAt)

            -- These 2 get annoying sometimes when painting
            -- , Mouse.onLeave (.offsetPos >> EndAt)
            -- , Mouse.onContextMenu (.offsetPos >> EndAt)
            , onTouch "touchstart" (touchCoordinates >> StartAt)
            , onTouch "touchmove" (touchCoordinates >> MoveAt)
            , onTouch "touchend" (touchCoordinates >> EndAt)
            ]
            toDraw
        , div
            [ style "max-width" (String.fromInt (w - 20) ++ "px")
            , style "padding" "10px"
            ]
            [ sizeControls color size
            , colorButtons color
            ]
        ]


sizeControls selectedColor selectedSize =
    let
        brushes =
            6

        inc =
            10

        buttonSize =
            brushes * inc

        controls =
            List.range 0 brushes
                |> List.map
                    (\i ->
                        let
                            size =
                                max 2 (i * inc)
                        in
                        button
                            [ style "-webkit-appearance" "none"
                            , style "-moz-appearance" "none"
                            , style "display" "block"
                            , style "background-color" "transparent"
                            , style "border" "none"
                            , style "margin" "5px"
                            , style "padding" "0"
                            , style "min-width" (String.fromInt 30 ++ "px")
                            , style "min-height" (String.fromInt buttonSize ++ "px")
                            , style "outline" "none"
                            , onClick (SelectSize size)
                            ]
                            [ div
                                [ style "border-radius" "50%"
                                , style "background-color" (colorToCSSString selectedColor)
                                , style "border" ("3px solid " ++ (Color.white |> getShadowColor |> colorToCSSString))
                                , style "width" (String.fromInt size ++ "px")
                                , style "height" (String.fromInt size ++ "px")
                                , style "margin" "0 auto"
                                , style "box-shadow"
                                    (if selectedSize == size then
                                        "rgba(0, 0, 0, 0.4) 0px 4px 6px"

                                     else
                                        "none"
                                    )
                                , style "transition" "transform 0.2s linear"
                                , style "transform"
                                    (if selectedSize == size then
                                        "translateY(-6px)"

                                     else
                                        "none"
                                    )
                                ]
                                []
                            ]
                    )
    in
    div
        [ style "display" "flex"
        , style "flex-direction" "row"
        , style "justify-content" "space-around"
        , style "align-items" "center"
        ]
        controls


colorButtons selectedColor =
    let
        layout colors =
            colors
                |> List.map (List.map (colorButton selectedColor) >> col)
    in
    div
        [ style "display" "flex"
        , style "flex-direction" "row"
        , style "justify-content" "space-around"
        ]
    <|
        layout
            [ [ Color.lightRed
              , Color.red
              , Color.darkRed
              ]
            , [ Color.lightOrange
              , Color.orange
              , Color.darkOrange
              ]
            , [ Color.lightYellow
              , Color.yellow
              , Color.darkYellow
              ]
            , [ Color.lightGreen
              , Color.green
              , Color.darkGreen
              ]
            , [ Color.lightBlue
              , Color.blue
              , Color.darkBlue
              ]
            , [ Color.lightPurple
              , Color.purple
              , Color.darkPurple
              ]
            , [ Color.lightBrown
              , Color.brown
              , Color.darkBrown
              ]
            , [ Color.white
              , Color.lightGrey
              , Color.grey
              ]
            , [ Color.darkGrey
              , Color.lightCharcoal
              , Color.charcoal
              ]
            , [ Color.darkCharcoal
              , Color.black
              ]
            ]


col btns =
    div [] btns


colorButton selectedColor color =
    button
        [ style "border-radius" "50%"
        , style "background-color" (colorToCSSString color)
        , style "display" "block"
        , style "width" "40px"
        , style "height" "40px"
        , style "margin" "5px"
        , style "border" "2px solid white"
        , style "box-shadow"
            (if selectedColor == color then
                "rgba(0, 0, 0, 0.4) 0px 4px 6px"

             else
                "none"
            )
        , style "transition" "transform 0.2s linear"
        , style "outline" "none"
        , style "transform"
            (if selectedColor == color then
                "translateY(-6px)"

             else
                "none"
            )
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
        ++ String.fromInt red
        ++ ", "
        ++ String.fromInt green
        ++ ", "
        ++ String.fromInt blue
        ++ ", "
        ++ String.fromFloat alpha
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
                ( x - x2, y - y2 )
            )
        |> Maybe.withDefault ( 0, 0 )


onTouch event tag =
    eventDecoder
        |> Decode.map
            (\ev ->
                { message = tag ev
                , preventDefault = True
                , stopPropagation = True
                }
            )
        |> Html.Events.custom event


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
    Decode.field "target"
        (Decode.map2 (\top left -> ( left, top ))
            (Decode.field "offsetTop" Decode.float)
            (Decode.field "offsetLeft" Decode.float)
        )



-- log msg thingToLog thingToReturn =
--     Debug.log msg thingToLog
--         |> (\_ -> thingToReturn)
