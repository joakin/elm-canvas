module Canvas exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Encode as Encode exposing (..)
import Color exposing (Color)


type alias Command =
    Encode.Value



-- HTML


element : Int -> Int -> List (Attribute msg) -> List Command -> Html msg
element w h attrs cmds =
    Html.node "elm-canvas"
        [ commands cmds ]
        [ canvas (List.concat [ [ height h, width w ], attrs ]) []
        ]



-- Properties


fillStyle : Color -> Command
fillStyle color =
    color
        |> colorToCSSString
        |> string
        |> field "fillStyle"


font : String -> Command
font f =
    field "font" (string f)


globalAlpha : Float -> Command
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


globalCompositeOperation : GlobalCompositeOperationMode -> Command
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


lineCap : LineCap -> Command
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


lineDashOffset : Float -> Command
lineDashOffset value =
    field "lineDashOffset" (float value)


type LineJoin
    = BevelJoin
    | RoundJoin
    | MiterJoin


lineJoin : LineJoin -> Command
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


lineWidth : Float -> Command
lineWidth value =
    field "lineWidth" (float value)


miterLimit : Float -> Command
miterLimit value =
    field "miterLimit" (float value)


shadowBlur : Float -> Command
shadowBlur value =
    field "shadowBlur" (float value)


shadowColor : Color -> Command
shadowColor color =
    color
        |> colorToCSSString
        |> string
        |> field "shadowColor"


shadowOffsetX : Float -> Command
shadowOffsetX value =
    field "shadowOffsetX" (float value)


shadowOffsetY : Float -> Command
shadowOffsetY value =
    field "shadowOffsetY" (float value)


strokeStyle : Color -> Command
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


textAlign : TextAlign -> Command
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


textBaseline : TextBaseLine -> Command
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


arc : Float -> Float -> Float -> Float -> Float -> Bool -> Command
arc x y radius startAngle endAngle anticlockwise =
    fn "arc" [ float x, float y, float radius, float 0, float (2 * pi), bool anticlockwise ]


arcTo : Float -> Float -> Float -> Float -> Float -> Command
arcTo x1 y1 x2 y2 radius =
    fn "arc" [ float x1, float y1, float x2, float y2, float radius ]


beginPath : Command
beginPath =
    fn "beginPath" []


bezierCurveTo : Float -> Float -> Float -> Float -> Float -> Float -> Command
bezierCurveTo cp1x cp1y cp2x cp2y x y =
    fn "bezierCurveTo" [ float cp1x, float cp1y, float cp2x, float cp2y, float x, float y ]


clearRect : Float -> Float -> Float -> Float -> Command
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


clip : FillRule -> Command
clip fillRule =
    fn "clip"
        [ string (fillRuleToString fillRule) ]


closePath : Command
closePath =
    fn "closePath" []


fill : FillRule -> Command
fill fillRule =
    fn "fill"
        [ string (fillRuleToString fillRule) ]


fillCircle : Float -> Float -> Float -> Command
fillCircle x y r =
    batch
        [ beginPath
        , arc x y r 0 (2 * pi) False
        , fill NonZero
        ]


fillRect : Float -> Float -> Float -> Float -> Command
fillRect x y w h =
    fn "fillRect" [ float x, float y, float w, float h ]


fillText : String -> Float -> Float -> Maybe Float -> Command
fillText text x y maxWidth =
    case maxWidth of
        Nothing ->
            fn "fillText" [ string text, float x, float y ]

        Just maxWidth ->
            fn "fillText" [ string text, float x, float y, float maxWidth ]


lineTo : Float -> Float -> Command
lineTo x y =
    fn "lineTo" [ float x, float y ]


moveTo : Float -> Float -> Command
moveTo x y =
    fn "moveTo" [ float x, float y ]


quadraticCurveTo : Float -> Float -> Float -> Float -> Command
quadraticCurveTo cpx cpy x y =
    fn "quadraticCurveTo" [ float cpx, float cpy, float x, float y ]


rect : Float -> Float -> Float -> Float -> Command
rect x y w h =
    fn "rect" [ float x, float y, float w, float h ]


restore : Command
restore =
    fn "restore" []


rotate : Float -> Command
rotate angle =
    fn "rotate" [ float angle ]


save : Command
save =
    fn "save" []


scale : Float -> Float -> Command
scale x y =
    fn "scale" [ float x, float y ]


setLineDash : List Float -> Command
setLineDash segments =
    fn "setLineDash" [ Encode.list (List.map float segments) ]


setTransform : Float -> Float -> Float -> Float -> Float -> Float -> Command
setTransform a b c d e f =
    fn "setTransform" [ float a, float b, float c, float d, float e, float f ]


stroke : Command
stroke =
    fn "stroke" []


strokeRect : Float -> Float -> Float -> Float -> Command
strokeRect x y w h =
    fn "strokeRect" [ float x, float y, float w, float h ]


strokeText : String -> Float -> Float -> Maybe Float -> Command
strokeText text x y maxWidth =
    case maxWidth of
        Nothing ->
            fn "strokeText" [ string text, float x, float y ]

        Just maxWidth ->
            fn "strokeText" [ string text, float x, float y, float maxWidth ]


transform : Float -> Float -> Float -> Float -> Float -> Float -> Command
transform a b c d e f =
    fn "transform" [ float a, float b, float c, float d, float e, float f ]


translate : Float -> Float -> Command
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


commands : List Command -> Attribute msg
commands list =
    property "cmds" (Encode.list list)


field : String -> Command -> Command
field name value =
    Encode.object [ ( "type", string "field" ), ( "name", string name ), ( "value", value ) ]


fn : String -> List Command -> Command
fn name args =
    Encode.object [ ( "type", string "function" ), ( "name", string name ), ( "args", Encode.list args ) ]


batch : List Command -> Command
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
