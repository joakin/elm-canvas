module Examples.Drawing exposing (main)

import Html exposing (..)
import Html.Attributes exposing (style)
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
    = AnimationFrame Time
    | StartAt ( Float, Float )
    | MoveAt ( Float, Float )
    | EndAt ( Float, Float )
    | SelectColor Color
    | SelectSize Int


init : Float -> ( Model, Cmd Msg )
init floatSeed =
    ({ frames = 0
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
    )
        ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ frames, drawingPointer, pending, toDraw } as model) =
    (case msg of
        AnimationFrame delta ->
            { model
                | frames = (frames + 1)
                , pending = Canvas.empty
                , toDraw = pending
            }

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
    )
        ! []


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


initialPoint (( x, y ) as point) ({ pending } as model) =
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
        [ p [ style [ ( "text-align", "center" ), ( "font-size", "80%" ) ] ] [ text "Draw something with the mouse!" ]
        , Canvas.element
            w
            h
            [ style [ ( "touch-action", "none" ) ]
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
            [ style
                [ ( "max-width", toString (w - 20) ++ "px" )
                , ( "padding", "10px" )
                ]
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
                                [ style
                                    [ ( "-webkit-appearance", "none" )
                                    , ( "-moz-appearance", "none" )
                                    , ( "display", "block" )
                                    , ( "background-color", "transparent" )
                                    , ( "border", "none" )
                                    , ( "margin", "5px" )
                                    , ( "padding", "0" )
                                    , ( "min-width", toString 30 ++ "px" )
                                    , ( "min-height", toString buttonSize ++ "px" )
                                    , ( "outline", "none" )
                                    ]
                                , onClick (SelectSize size)
                                ]
                                [ div
                                    [ style
                                        [ ( "border-radius", "50%" )
                                        , ( "background-color", colorToCSSString selectedColor )
                                        , ( "border", "3px solid " ++ (Color.white |> getShadowColor |> colorToCSSString) )
                                        , ( "width", toString size ++ "px" )
                                        , ( "height", toString size ++ "px" )
                                        , ( "margin", "0 auto" )
                                        , ( "box-shadow"
                                          , if selectedSize == size then
                                                "rgba(0, 0, 0, 0.4) 0px 4px 6px"
                                            else
                                                "none"
                                          )
                                        , ( "transition", "transform 0.2s linear" )
                                        , ( "transform"
                                          , if selectedSize == size then
                                                "translateY(-6px)"
                                            else
                                                "none"
                                          )
                                        ]
                                    ]
                                    []
                                ]
                    )
    in
        div
            [ style
                [ ( "display", "flex" )
                , ( "flex-direction", "row" )
                , ( "justify-content", "space-around" )
                , ( "align-items", "center" )
                ]
            ]
            controls


colorButtons selectedColor =
    let
        layout colors =
            colors
                |> List.map ((List.map (colorButton selectedColor)) >> col)
    in
        div
            [ style
                [ ( "display", "flex" )
                , ( "flex-direction", "row" )
                , ( "justify-content", "space-around" )
                ]
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
        [ style
            [ ( "border-radius", "50%" )
            , ( "background-color", colorToCSSString color )
            , ( "display", "block" )
            , ( "width", "40px" )
            , ( "height", "40px" )
            , ( "margin", "5px" )
            , ( "border", "2px solid white" )
            , ( "box-shadow"
              , if selectedColor == color then
                    "rgba(0, 0, 0, 0.4) 0px 4px 6px"
                else
                    "none"
              )
            , ( "transition", "transform 0.2s linear" )
            , ( "outline", "none" )
            , ( "transform"
              , if selectedColor == color then
                    "translateY(-6px)"
                else
                    "none"
              )
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
