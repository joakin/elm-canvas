module Canvas exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Encode as Encode exposing (..)
import Color exposing (Color)


-- HTML


element : Int -> Int -> List (Attribute msg) -> List Value -> Html msg
element w h attrs cmds =
    Html.node "elm-canvas"
        [ commands cmds ]
        [ canvas (List.concat [ [ height h, width w ], attrs ]) []
        ]



-- Properties


fillStyle : Color -> Value
fillStyle color =
    color
        |> colorToCSSString
        |> string
        |> field "fillStyle"


font : String -> Value
font f =
    field "font" (string f)


globalAlpha : Float -> Value
globalAlpha alpha =
    field "globalAlpha" (float alpha)


type GlobalCompositeOperationMode
    = SourceOver
    | SourceIn
    | SourceOut
    | SourceAtop
    | DestinationOver
    | DestinationIn
    | DestinationOut
    | DestinationAtop
    | Lighter
    | Copy
    | Xor
    | Multiply
    | Screen
    | Overlay
    | Darken
    | Lighten
    | ColorDodge
    | ColorBurn
    | HardLight
    | SoftLight
    | Difference
    | Exclusion
    | Hue
    | Saturation
    | Color
    | Luminosity


globalCompositeOperation : GlobalCompositeOperationMode -> Value
globalCompositeOperation mode =
    let
        stringMode =
            case mode of
                SourceOver ->
                    "source-over"

                SourceIn ->
                    "source-in"

                SourceOut ->
                    "source-out"

                SourceAtop ->
                    "source-atop"

                DestinationOver ->
                    "destination-over"

                DestinationIn ->
                    "destination-in"

                DestinationOut ->
                    "destination-out"

                DestinationAtop ->
                    "destination-atop"

                Lighter ->
                    "lighter"

                Copy ->
                    "copy"

                Xor ->
                    "xor"

                Multiply ->
                    "multiply"

                Screen ->
                    "screen"

                Overlay ->
                    "overlay"

                Darken ->
                    "darken"

                Lighten ->
                    "lighten"

                ColorDodge ->
                    "color-dodge"

                ColorBurn ->
                    "color-burn"

                HardLight ->
                    "hard-light"

                SoftLight ->
                    "soft-light"

                Difference ->
                    "difference"

                Exclusion ->
                    "exclusion"

                Hue ->
                    "hue"

                Saturation ->
                    "saturation"

                Color ->
                    "color"

                Luminosity ->
                    "luminosity"
    in
        field
            "globalCompositeOperation"
            (string stringMode)


type LineCap
    = ButtCap
    | RoundCap
    | SquareCap


lineCap : LineCap -> Value
lineCap cap =
    field "lineCap"
        (string
            (case cap of
                ButtCap ->
                    "butt"

                RoundCap ->
                    "round"

                SquareCap ->
                    "square"
            )
        )


lineDashOffset : Float -> Value
lineDashOffset value =
    field "lineDashOffset" (float value)


type LineJoin
    = BevelJoin
    | RoundJoin
    | MiterJoin


lineJoin : LineJoin -> Value
lineJoin join =
    field "lineJoin"
        (string
            (case join of
                BevelJoin ->
                    "bevel"

                RoundJoin ->
                    "round"

                MiterJoin ->
                    "miter"
            )
        )


lineWidth : Float -> Value
lineWidth value =
    field "lineWidth" (float value)


miterLimit : Float -> Value
miterLimit value =
    field "miterLimit" (float value)


shadowBlur : Float -> Value
shadowBlur value =
    field "shadowBlur" (float value)


shadowColor : Color -> Value
shadowColor color =
    color
        |> colorToCSSString
        |> string
        |> field "shadowColor"


shadowOffsetX : Float -> Value
shadowOffsetX value =
    field "shadowOffsetX" (float value)


shadowOffsetY : Float -> Value
shadowOffsetY value =
    field "shadowOffsetY" (float value)


strokeStyle : Color -> Value
strokeStyle color =
    {- TODO: support CanvasGradient and CanvasPattern -}
    color
        |> colorToCSSString
        |> string
        |> field "strokeStyle"


type TextAlign
    = Left
    | Right
    | Center
    | Start
    | End


textAlign : TextAlign -> Value
textAlign align =
    field "textAlign"
        (string
            (case align of
                Left ->
                    "left"

                Right ->
                    "right"

                Center ->
                    "center"

                Start ->
                    "start"

                End ->
                    "end"
            )
        )


type TextBaseLine
    = Top
    | Hanging
    | Middle
    | Alphabetic
    | Ideographic
    | Bottom


textBaseline : TextBaseLine -> Value
textBaseline baseline =
    field "textBaseline"
        (string
            (case baseline of
                Top ->
                    "top"

                Hanging ->
                    "hanging"

                Middle ->
                    "middle"

                Alphabetic ->
                    "alphabetic"

                Ideographic ->
                    "ideographic"

                Bottom ->
                    "bottom"
            )
        )



-- Methods


arc : Float -> Float -> Float -> Float -> Float -> Bool -> Value
arc x y radius startAngle endAngle anticlockwise =
    fn "arc" [ float x, float y, float radius, float 0, float (2 * pi), bool anticlockwise ]


arcTo : Float -> Float -> Float -> Float -> Float -> Value
arcTo x1 y1 x2 y2 radius =
    fn "arc" [ float x1, float y1, float x2, float y2, float radius ]


beginPath : Value
beginPath =
    fn "beginPath" []


bezierCurveTo : Float -> Float -> Float -> Float -> Float -> Float -> Value
bezierCurveTo cp1x cp1y cp2x cp2y x y =
    fn "bezierCurveTo" [ float cp1x, float cp1y, float cp2x, float cp2y, float x, float y ]


clearRect : Float -> Float -> Float -> Float -> Value
clearRect x y width height =
    fn "clearRect" [ float x, float y, float width, float height ]


type FillRule
    = NonZero
    | EvenOdd


fillRuleToString : FillRule -> String
fillRuleToString fillRule =
    case fillRule of
        NonZero ->
            "nonzero"

        EvenOdd ->
            "evenodd"


clip : FillRule -> Value
clip fillRule =
    fn "clip"
        [ string (fillRuleToString fillRule) ]


closePath : Value
closePath =
    fn "closePath" []


fill : FillRule -> Value
fill fillRule =
    fn "fill"
        [ string (fillRuleToString fillRule) ]


fillCircle : Float -> Float -> Float -> Value
fillCircle x y r =
    batch
        [ beginPath
        , arc x y r 0 (2 * pi) False
        , fill NonZero
        ]


fillRect : Float -> Float -> Float -> Float -> Value
fillRect x y w h =
    fn "fillRect" [ float x, float y, float w, float h ]


fillText : String -> Float -> Float -> Maybe Float -> Value
fillText text x y maxWidth =
    case maxWidth of
        Nothing ->
            fn "fillText" [ string text, float x, float y ]

        Just maxWidth ->
            fn "fillText" [ string text, float x, float y, float maxWidth ]


lineTo : Float -> Float -> Value
lineTo x y =
    fn "lineTo" [ float x, float y ]


moveTo : Float -> Float -> Value
moveTo x y =
    fn "moveTo" [ float x, float y ]


quadraticCurveTo : Float -> Float -> Float -> Float -> Value
quadraticCurveTo cpx cpy x y =
    fn "quadraticCurveTo" [ float cpx, float cpy, float x, float y ]


rect : Float -> Float -> Float -> Float -> Value
rect x y w h =
    fn "rect" [ float x, float y, float w, float h ]


restore : Value
restore =
    fn "restore" []


rotate : Float -> Value
rotate angle =
    fn "rotate" [ float angle ]


save : Value
save =
    fn "save" []


scale : Float -> Float -> Value
scale x y =
    fn "scale" [ float x, float y ]


setLineDash : List Float -> Value
setLineDash segments =
    fn "setLineDash" [ Encode.list (List.map float segments) ]


setTransform : Float -> Float -> Float -> Float -> Float -> Float -> Value
setTransform a b c d e f =
    fn "setTransform" [ float a, float b, float c, float d, float e, float f ]


stroke : Value
stroke =
    fn "stroke" []


strokeRect : Float -> Float -> Float -> Float -> Value
strokeRect x y w h =
    fn "strokeRect" [ float x, float y, float w, float h ]


strokeText : String -> Float -> Float -> Maybe Float -> Value
strokeText text x y maxWidth =
    case maxWidth of
        Nothing ->
            fn "strokeText" [ string text, float x, float y ]

        Just maxWidth ->
            fn "strokeText" [ string text, float x, float y, float maxWidth ]


transform : Float -> Float -> Float -> Float -> Float -> Float -> Value
transform a b c d e f =
    fn "transform" [ float a, float b, float c, float d, float e, float f ]


translate : Float -> Float -> Value
translate x y =
    fn "translate" [ float x, float y ]



{- TODO: Should these functions be supported:
   - createImageData
   - createLinearGradient
   - createPattern
   - createRadialGradient
   - drawFocusIfNeeded
   - drawImage
   - getImageData
   - isPointInPath
   - isPointInStroke
   - isPointInStroke
   - measureText
   - putImageData

   Also there are other functions that can take a path as an argument, or an
   image data or gradient or pattern, so if we supported some of these we could
   add variants for those other functions
-}
--
-- Lowest level


commands : List Value -> Attribute msg
commands list =
    property "cmds" (Encode.list list)


field : String -> Encode.Value -> Encode.Value
field name value =
    Encode.object [ ( "type", string "field" ), ( "name", string name ), ( "value", value ) ]


fn : String -> List Encode.Value -> Encode.Value
fn name args =
    Encode.object [ ( "type", string "function" ), ( "name", string name ), ( "args", Encode.list args ) ]


batch : List Encode.Value -> Encode.Value
batch values =
    Encode.object [ ( "type", string "batch" ), ( "values", Encode.list values ) ]



-- Helpers


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
