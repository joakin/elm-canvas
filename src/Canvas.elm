module Canvas
    exposing
        ( Command
        , element
        , batch
        , fillStyle
        , strokeStyle
        , font
        , TextAlign(..)
        , textAlign
        , TextBaseLine(..)
        , textBaseline
        , fillText
        , strokeText
        , clearRect
        , fillCircle
        , fillRect
        , strokeRect
        , beginPath
        , closePath
        , FillRule(..)
        , fill
        , clip
        , stroke
        , arc
        , arcTo
        , bezierCurveTo
        , lineTo
        , moveTo
        , quadraticCurveTo
        , rect
        , LineCap(..)
        , lineCap
        , lineDashOffset
        , LineJoin(..)
        , lineJoin
        , lineWidth
        , miterLimit
        , setLineDash
        , shadowBlur
        , shadowColor
        , shadowOffsetX
        , shadowOffsetY
        , globalAlpha
        , GlobalCompositeOperationMode(..)
        , globalCompositeOperation
        , save
        , restore
        , rotate
        , scale
        , translate
        , transform
        , setTransform
        )

{-| This library exposes a low level API that mirrors most of the DOM canvas
API.

To use it, remember to include the `elm-canvas` custom element script in your
page before you initialize your Elm application.

  - <http://unpkg.com/elm-canvas/elm-canvas.js>
  - <http://npmjs.com/package/elm-canvas>

WARNING: This library is intended as a very low-level API that mirrors the DOM
API almost exactly, while providing a bit of extra type safety where it makes
sense. The DOM API is highly stateful and side-effectful, so be careful. To
understand how to use this library properly, please read the MDN docs:
<https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D> and
all the nested pages


# Usage in HTML

@docs element


# Composing Commands

@docs Command, batch


# Colors

@docs fillStyle, strokeStyle


# Text

@docs font, TextAlign, textAlign, TextBaseLine, textBaseline, fillText, strokeText


# Shapes

@docs clearRect, fillCircle, fillRect, strokeRect


# Paths

@docs beginPath, closePath, FillRule, fill, clip, stroke, arc, arcTo, bezierCurveTo, lineTo, moveTo, quadraticCurveTo, rect


# Line settings

@docs LineCap, lineCap, lineDashOffset, LineJoin, lineJoin, lineWidth, miterLimit, setLineDash


# Shadows

@docs shadowBlur, shadowColor, shadowOffsetX, shadowOffsetY


# Global Canvas settings

@docs globalAlpha, GlobalCompositeOperationMode, globalCompositeOperation, save, restore


# Global Canvas transforms

@docs rotate, scale, translate, transform, setTransform

-}

import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Encode as Encode exposing (..)
import Color exposing (Color)


{-| Represents a command to execute on the DOM canvas. You build commands with
the helper functions the library exposes, which mirror the canvas API.

Then, you pass the commands to the `element` you render on the view, and they
will be run!

-}
type alias Command =
    Encode.Value



-- HTML


{-| Create a Html element that you can use in your view.

    view : Model -> Html Msg
    view { isRunning, time } =
        Canvas.element
            width
            height
            [ onClick ToggleRunning ]
            [ Canvas.clearScreen
            , Canvas.fillStyle (Color.rgba 0 0 0 1)
            , List.range 0 100
                |> List.map (renderItem time)
                |> batch
            ]

-}
element : Int -> Int -> List (Attribute msg) -> List Command -> Html msg
element w h attrs cmds =
    Html.node "elm-canvas"
        [ commands cmds ]
        [ canvas (List.concat [ [ height h, width w ], attrs ]) []
        ]



-- Properties


{-| Specifies the color or style to use inside shapes. The default is #000
(black). [MDN Docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/fillStyle)

    fillStyle (Color.rgba 125 200 255 0.6)

-}
fillStyle : Color -> Command
fillStyle color =
    color
        |> colorToCSSString
        |> string
        |> field "fillStyle"


{-| Specifies the current text style being used when drawing text. This string
uses the same syntax as the [CSS
font](https://developer.mozilla.org/en-US/docs/Web/CSS/font) specifier. The
default font is 10px sans-serif. [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/font)

    [ font "48px serif"
    , strokeText "Hello world" 50 100
    ]

-}
font : String -> Command
font f =
    field "font" (string f)


{-| Specifies the alpha value that is applied to shapes and images before they are
drawn onto the canvas. The value is in the range from 0.0 (fully transparent) to
1.0 (fully opaque). The default value is 1.0. Values outside the range,
including `Infinity` and `NaN` will not be set and globalAlpha will retain its
previous value.

See also the chapter [Applying styles and color](https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API/Tutorial/Applying_styles_and_colors). [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/globalAlpha)

    -- Drawing two transparent rectangles
    [ globalAlpha 0.5
    , fillStyle (Color.rgb 0 0 255)
    , fillRect 10 10 100 100
    , fillStyle (Color.rgb 255 0 0)
    , fillRect 50 50 100 100
    ]

-}
globalAlpha : Float -> Command
globalAlpha alpha =
    field "globalAlpha" (float alpha)


{-| Type of compositing operation, identifying which of the compositing or
blending mode operations to use. See the chapter
[Compositing](https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API/Tutorial/Compositing)
from the Canvas Tutorial.

For more information and pictures of what each mode does, see the [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/globalCompositeOperation).

-}
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


{-| Sets the type of compositing operation to apply when drawing new shapes,
where type is a `GlobalCompositeOperationMode` identifying which of the
compositing or blending mode operations to use.

See the chapter
[Compositing](https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API/Tutorial/Compositing)
from the Canvas Tutorial, or visit the [MDN
docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/globalCompositeOperation)
for more information and pictures of what each mode does.

    globalCompositeOperation Screen

-}
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


{-| Type of end points for line drawn.

  - ButtCap
      - The ends of lines are squared off at the endpoints.
  - RoundCap
      - The ends of lines are rounded.
  - SquareCap
      - The ends of lines are squared off by adding a box with an equal width
        and half the height of the line's thickness.

-}
type LineCap
    = ButtCap
    | RoundCap
    | SquareCap


{-| Determines how the end points of every line are drawn. See `LineCap` for the
possible types. By default this property is set to `ButtCap`. [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/lineCap)

    [ beginPath
    , moveTo 0 0
    , lineWidth 15
    , lineCap RoundCap
    , lineTo 100 100
    , stroke
    ]

-}
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


{-| Sets the line dash pattern offset or "phase". [MDN
docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/lineDashOffset)

    [ setLineDash [4, 16]
    , lineDashOffset 2
    , beginPath
    , moveTo 0 100
    , lineTo 400 100
    , stroke
    ]

-}
lineDashOffset : Float -> Command
lineDashOffset value =
    field "lineDashOffset" (float value)


{-| Determines how two connecting segments with non-zero lengths in a shape are
joined together. [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/lineJoin)

  - Round
      - Rounds off the corners of a shape by filling an additional sector of disc
        centered at the common endpoint of connected segments. The radius for these
        rounded corners is equal to the line width.
  - Bevel
      - Fills an additional triangular area between the common endpoint of
        connected segments, and the separate outside rectangular corners of each segment.
  - Miter
      - Connected segments are joined by extending their outside edges to connect
        at a single point, with the effect of filling an additional lozenge-shaped
        area. This setting is affected by the miterLimit property.

-}
type LineJoin
    = BevelJoin
    | RoundJoin
    | MiterJoin


{-| Sets how two connecting segments (of lines, arcs or curves) with
non-zero lengths in a shape are joined together (degenerate segments with zero
lengths, whose specified endpoints and control points are exactly at the same
position, are skipped). See the type `LineJoin`.

By default this property is set to `MiterJoin`. Note that the lineJoin setting
has no effect if the two connected segments have the same direction, because no
joining area will be added in this case.

[MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/lineJoin)

    [ lineWidth 10
    , lineJoin RoundJoin
    , beginPath
    , moveTo 0 0
    , lineTo 200 100
    , lineTo 300 0
    , stroke
    ]

-}
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


{-| Sets the thickness of lines in space units. When setting, zero, negative,
Infinity and NaN values are ignored; otherwise the current value is set to the
new value. [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/lineWidth)

    [ beginPath
    , moveTo 0 0
    , lineWidth 15
    , lineTo 100 100
    , stroke
    ]

-}
lineWidth : Float -> Command
lineWidth value =
    field "lineWidth" (float value)


{-| Sets the miter limit ratio in space units. When setting, zero, negative,
Infinity and NaN values are ignored; otherwise the current value is set to the
new value. [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/miterLimit)
-}
miterLimit : Float -> Command
miterLimit value =
    field "miterLimit" (float value)


{-| Specifies the level of the blurring effect; this value doesn't correspond to
a number of pixels and is not affected by the current transformation matrix. The
default value is 0. Negative, Infinity or NaN values are ignored. Note that
shadows are only drawn, if the `shadowColor` property is set to
a non-transparent value. [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/shadowBlur)

    [ shadowColor (Color.rgb 0 0 0)
    , shadowBlur 10
    , fillStyle (Color.rgb 255 255 255)
    , fillRect 10 10 100 100
    ]

-}
shadowBlur : Float -> Command
shadowBlur value =
    field "shadowBlur" (float value)


{-| Specifies the color of the shadow. [MDN
docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/shadowColor)

Note that shadows are only drawn, if the shadowColor property is set
(non-transparent) and either the shadowBlur, the shadowOffsetX, or the
shadowOffsetY property are non-zero.

    [ shadowColor (Color.rgb 0 0 0)
    , shadowOffsetY 10
    , shadowOffsetX 10
    , fillStyle (Color.rgb 0 255 0)
    , fillRect 10 10 100 100
    ]

-}
shadowColor : Color -> Command
shadowColor color =
    color
        |> colorToCSSString
        |> string
        |> field "shadowColor"


{-| Specifies the distance that the shadow will be offset in horizontal
distance. [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/shadowOffsetX)

The default value is 0. Infinity or NaN values are ignored.

    [ shadowColor (Color.rgb 0 0 0)
    , shadowOffsetY 10
    , shadowOffsetX 10
    , fillStyle (Color.rgb 0 255 0)
    , fillRect 10 10 100 100
    ]

-}
shadowOffsetX : Float -> Command
shadowOffsetX value =
    field "shadowOffsetX" (float value)


{-| Specifies the distance that the shadow will be offset in vertical
distance. [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/shadowOffsetY)

The default value is 0. Infinity or NaN values are ignored.

    [ shadowColor (Color.rgb 0 0 0)
    , shadowOffsetY 10
    , shadowOffsetX 10
    , fillStyle (Color.rgb 0 255 0)
    , fillRect 10 10 100 100
    ]

-}
shadowOffsetY : Float -> Command
shadowOffsetY value =
    field "shadowOffsetY" (float value)


{-| Specifies the color or style to use for the lines around shapes. The default
is #000 (black). [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/strokeStyle)

    [ strokeStyle (Color.rgb 0 0 255)
    , strokeRect 10 10 100 100
    ]

-}
strokeStyle : Color -> Command
strokeStyle color =
    {- TODO: support CanvasGradient and CanvasPattern -}
    color
        |> colorToCSSString
        |> string
        |> field "strokeStyle"


{-| Type of text alignment

  - Left
      - The text is left-aligned.
  - Right
      - The text is right-aligned.
  - Center
      - The text is centered.
  - Start
      - The text is aligned at the normal start of the line (left-aligned for
        left-to-right locales, right-aligned for right-to-left locales).
  - End
      - The text is aligned at the normal end of the line (right-aligned for
        left-to-right locales, left-aligned for right-to-left locales).

-}
type TextAlign
    = Left
    | Right
    | Center
    | Start
    | End


{-| Specifies the current text alignment being used when drawing text. Beware
that the alignment is based on the x value of the `fillText` command. So if
`textAlign` is `Center`, then the text would be drawn at `x - (width / 2)`.

The default value is `Start`. [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/textAlign)

    [ font "48px serif"
    , textAlign Left
    , strokeText "Hello world" 0 100
    ]

-}
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


{-| Type of text baseline.

  - Top
      - The text baseline is the top of the em square.
  - Hanging
      - The text baseline is the hanging baseline. (Used by Tibetan and other Indic scripts.)
  - Middle
      - The text baseline is the middle of the em square.
  - Alphabetic
      - The text baseline is the normal alphabetic baseline.
  - Ideographic
      - The text baseline is the ideographic baseline; this is the bottom of the body of the characters, if the main body of characters protrudes beneath the alphabetic baseline. (Used by Chinese, Japanese and Korean scripts.)
  - Bottom
      - The text baseline is the bottom of the bounding box. This differs from the ideographic baseline in that the ideographic baseline doesn't consider descenders.

-}
type TextBaseLine
    = Top
    | Hanging
    | Middle
    | Alphabetic
    | Ideographic
    | Bottom


{-| Specifies the current text baseline being used when drawing text.

The default value is `Alphabetic`. [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/textBaseline)

See [MDN
docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/textBaseline)
for examples and rendering of the different modes.

-}
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


{-| -}
arc : Float -> Float -> Float -> Float -> Float -> Bool -> Command
arc x y radius startAngle endAngle anticlockwise =
    fn "arc" [ float x, float y, float radius, float 0, float (2 * pi), bool anticlockwise ]


{-| -}
arcTo : Float -> Float -> Float -> Float -> Float -> Command
arcTo x1 y1 x2 y2 radius =
    fn "arc" [ float x1, float y1, float x2, float y2, float radius ]


{-| -}
beginPath : Command
beginPath =
    fn "beginPath" []


{-| -}
bezierCurveTo : Float -> Float -> Float -> Float -> Float -> Float -> Command
bezierCurveTo cp1x cp1y cp2x cp2y x y =
    fn "bezierCurveTo" [ float cp1x, float cp1y, float cp2x, float cp2y, float x, float y ]


{-| -}
clearRect : Float -> Float -> Float -> Float -> Command
clearRect x y width height =
    fn "clearRect" [ float x, float y, float width, float height ]


{-| -}
type FillRule
    = NonZero
    | EvenOdd


{-| -}
fillRuleToString : FillRule -> String
fillRuleToString fillRule =
    case fillRule of
        NonZero ->
            "nonzero"

        EvenOdd ->
            "evenodd"


{-| -}
clip : FillRule -> Command
clip fillRule =
    fn "clip"
        [ string (fillRuleToString fillRule) ]


{-| -}
closePath : Command
closePath =
    fn "closePath" []


{-| -}
fill : FillRule -> Command
fill fillRule =
    fn "fill"
        [ string (fillRuleToString fillRule) ]


{-| -}
fillCircle : Float -> Float -> Float -> Command
fillCircle x y r =
    batch
        [ beginPath
        , arc x y r 0 (2 * pi) False
        , fill NonZero
        ]


{-| -}
fillRect : Float -> Float -> Float -> Float -> Command
fillRect x y w h =
    fn "fillRect" [ float x, float y, float w, float h ]


{-| -}
fillText : String -> Float -> Float -> Maybe Float -> Command
fillText text x y maxWidth =
    case maxWidth of
        Nothing ->
            fn "fillText" [ string text, float x, float y ]

        Just maxWidth ->
            fn "fillText" [ string text, float x, float y, float maxWidth ]


{-| -}
lineTo : Float -> Float -> Command
lineTo x y =
    fn "lineTo" [ float x, float y ]


{-| -}
moveTo : Float -> Float -> Command
moveTo x y =
    fn "moveTo" [ float x, float y ]


{-| -}
quadraticCurveTo : Float -> Float -> Float -> Float -> Command
quadraticCurveTo cpx cpy x y =
    fn "quadraticCurveTo" [ float cpx, float cpy, float x, float y ]


{-| -}
rect : Float -> Float -> Float -> Float -> Command
rect x y w h =
    fn "rect" [ float x, float y, float w, float h ]


{-| -}
restore : Command
restore =
    fn "restore" []


{-| -}
rotate : Float -> Command
rotate angle =
    fn "rotate" [ float angle ]


{-| -}
save : Command
save =
    fn "save" []


{-| -}
scale : Float -> Float -> Command
scale x y =
    fn "scale" [ float x, float y ]


{-| -}
setLineDash : List Float -> Command
setLineDash segments =
    fn "setLineDash" [ Encode.list (List.map float segments) ]


{-| -}
setTransform : Float -> Float -> Float -> Float -> Float -> Float -> Command
setTransform a b c d e f =
    fn "setTransform" [ float a, float b, float c, float d, float e, float f ]


{-| -}
stroke : Command
stroke =
    fn "stroke" []


{-| -}
strokeRect : Float -> Float -> Float -> Float -> Command
strokeRect x y w h =
    fn "strokeRect" [ float x, float y, float w, float h ]


{-| -}
strokeText : String -> Float -> Float -> Maybe Float -> Command
strokeText text x y maxWidth =
    case maxWidth of
        Nothing ->
            fn "strokeText" [ string text, float x, float y ]

        Just maxWidth ->
            fn "strokeText" [ string text, float x, float y, float maxWidth ]


{-| -}
transform : Float -> Float -> Float -> Float -> Float -> Float -> Command
transform a b c d e f =
    fn "transform" [ float a, float b, float c, float d, float e, float f ]


{-| -}
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


{-| Batch a list of Commands into a single Command. Useful to compose functions
that generate lists of commands without having to do List manipulations all the time.

    clearScreen : Command
    clearScreen =
        batch
            [ clearRect 0 0 400 400
            , fillStyle (Color.rgb 0 0 0)
            ]

-}
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
