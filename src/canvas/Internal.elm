module Canvas.Internal exposing
    ( Commands, empty
    , fillStyle, strokeStyle
    , font, textAlign, textBaseline, fillText, strokeText
    , fillRect, strokeRect, clearRect
    , beginPath, closePath, FillRule(..), fill, clip, stroke, arc, arcTo, bezierCurveTo, lineTo, moveTo, quadraticCurveTo, rect, circle
    , lineCap, lineDashOffset, lineJoin, lineWidth, miterLimit, setLineDash
    , shadowBlur, shadowColor, shadowOffsetX, shadowOffsetY
    , globalAlpha, globalCompositeOperation, save, restore
    , rotate, scale, translate, transform, setTransform
    , Command, commands
    )

{-| This module exposes a low level drawing API to work with the DOM canvas.

See instructions in the main page of the package for installation, as it
requires a web component.

**WARNING**: This library is in development and right now it only exposes a
low-level API that mirrors the DOM API, providing a bit of extra type safety
where it makes sense. The DOM API is highly stateful and side-effectful, so be
careful. To understand how to use this library for now, please familiarize
yourself with the
[MDN Canvas Tutorial](https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API/Tutorial).
We will be iterating on the design of the library to make it nicer and provide
better defaults as time goes by, and make specific tutorials with Elm.


# Composing Commands

@docs Commands, empty


# Colors

@docs fillStyle, strokeStyle


# Text

@docs font, textAlign, textBaseline, fillText, strokeText


# Shapes

@docs fillRect, strokeRect, clearRect


# Paths

@docs beginPath, closePath, FillRule, fill, clip, stroke, arc, arcTo, bezierCurveTo, lineTo, moveTo, quadraticCurveTo, rect, circle


# Line settings

@docs lineCap, lineDashOffset, LineJoin, lineJoin, lineWidth, miterLimit, setLineDash


# Shadows

@docs shadowBlur, shadowColor, shadowOffsetX, shadowOffsetY, shadowOffset


# Global Canvas settings

@docs globalAlpha, globalCompositeOperation, save, restore


# Global Canvas transforms

@docs rotate, scale, translate, transform, setTransform

-}

import Canvas.Color as Color exposing (Color)
import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Encode as Encode exposing (..)


type alias Commands =
    List Command


type alias Command =
    Encode.Value


empty =
    []



-- Properties


{-| Specifies the color or style to use inside shapes. The default is #000
(black). [MDN Docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/fillStyle)

    empty |> fillStyle (Color.rgba 125 200 255 0.6)

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

    empty
        |> font "48px serif"
        |> strokeText "Hello world" 50 100

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
    empty
        |> globalAlpha 0.5
        |> fillStyle (Color.rgb 0 0 255)
        |> fillRect 10 10 100 100
        |> fillStyle (Color.rgb 255 0 0)
        |> fillRect 50 50 100 100

-}
globalAlpha : Float -> Command
globalAlpha alpha =
    field "globalAlpha" (float alpha)


{-| Sets the type of compositing operation to apply when drawing new shapes,
where type is a `GlobalCompositeOperationMode` string identifying which of the
compositing or blending mode operations to use.

See the chapter
[Compositing](https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API/Tutorial/Compositing)
from the Canvas Tutorial, or visit the [MDN
docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/globalCompositeOperation)
for more information and pictures of what each mode does.

    empty |> globalCompositeOperation Screen

-}
globalCompositeOperation : String -> Command
globalCompositeOperation mode =
    field "globalCompositeOperation" (string mode)


{-| Determines how the end points of every line are drawn. See `LineCap` for the
possible types. By default this property is set to `ButtCap`. [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/lineCap)

    empty
        |> beginPath
        |> moveTo 0 0
        |> lineWidth 15
        |> lineCap RoundCap
        |> lineTo 100 100
        |> stroke

-}
lineCap : String -> Command
lineCap cap =
    field "lineCap"
        (string
            cap
        )


{-| Sets the line dash pattern offset or "phase". [MDN
docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/lineDashOffset)

    empty
        |> setLineDash [ 4, 16 ]
        |> lineDashOffset 2
        |> beginPath
        |> moveTo 0 100
        |> lineTo 400 100
        |> stroke

-}
lineDashOffset : Float -> Command
lineDashOffset value =
    field "lineDashOffset" (float value)


{-| Sets how two connecting segments (of lines, arcs or curves) with
non-zero lengths in a shape are joined together (degenerate segments with zero
lengths, whose specified endpoints and control points are exactly at the same
position, are skipped). See the type `LineJoin`.

By default this property is set to `MiterJoin`. Note that the lineJoin setting
has no effect if the two connected segments have the same direction, because no
joining area will be added in this case.

[MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/lineJoin)

    empty
        |> lineWidth 10
        |> lineJoin RoundJoin
        |> beginPath
        |> moveTo 0 0
        |> lineTo 200 100
        |> lineTo 300 0
        |> stroke

-}
lineJoin : String -> Command
lineJoin join =
    field "lineJoin" (string join)


{-| Sets the thickness of lines in space units. When setting, zero, negative,
Infinity and NaN values are ignored; otherwise the current value is set to the
new value. [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/lineWidth)

    empty
        |> beginPath
        |> moveTo 0 0
        |> lineWidth 15
        |> lineTo 100 100
        |> stroke

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

    empty
        |> shadowColor (Color.rgb 0 0 0)
        |> shadowBlur 10
        |> fillStyle (Color.rgb 255 255 255)
        |> fillRect 10 10 100 100

-}
shadowBlur : Float -> Command
shadowBlur value =
    field "shadowBlur" (float value)


{-| Specifies the color of the shadow. [MDN
docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/shadowColor)

Note that shadows are only drawn, if the shadowColor property is set
(non-transparent) and either the shadowBlur, the shadowOffsetX, or the
shadowOffsetY property are non-zero.

    empty
        |> shadowColor (Color.rgb 0 0 0)
        |> shadowOffsetY 10
        |> shadowOffsetX 10
        |> fillStyle (Color.rgb 0 255 0)
        |> fillRect 10 10 100 100

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

    empty
        |> shadowColor (Color.rgb 0 0 0)
        |> shadowOffsetY 10
        |> shadowOffsetX 10
        |> fillStyle (Color.rgb 0 255 0)
        |> fillRect 10 10 100 100

-}
shadowOffsetX : Float -> Command
shadowOffsetX value =
    field "shadowOffsetX" (float value)


{-| Specifies the distance that the shadow will be offset in vertical
distance. [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/shadowOffsetY)

The default value is 0. Infinity or NaN values are ignored.

    empty
        |> shadowColor (Color.rgb 0 0 0)
        |> shadowOffsetY 10
        |> shadowOffsetX 10
        |> fillStyle (Color.rgb 0 255 0)
        |> fillRect 10 10 100 100

-}
shadowOffsetY : Float -> Command
shadowOffsetY value =
    field "shadowOffsetY" (float value)


{-| Specifies the color or style to use for the lines around shapes. The default
is #000 (black). [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/strokeStyle)

    empty
        |> strokeStyle (Color.rgb 0 0 255)
        |> strokeRect 10 10 100 100

-}
strokeStyle : Color -> Command
strokeStyle color =
    {- TODO: support CanvasGradient and CanvasPattern -}
    color
        |> colorToCSSString
        |> string
        |> field "strokeStyle"


{-| Specifies the current text alignment being used when drawing text. Beware
that the alignment is based on the x value of the `fillText` command. So if
`textAlign` is `Center`, then the text would be drawn at `x - (width / 2)`.

The default value is `Start`. [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/textAlign)

    empty
        |> font "48px serif"
        |> textAlign Left
        |> strokeText "Hello world" 0 100

-}
textAlign : String -> Command
textAlign align =
    field "textAlign" (string align)


{-| Specifies the current text baseline being used when drawing text.

The default value is `Alphabetic`.

See [MDN
docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/textBaseline)
for examples and rendering of the different modes.

-}
textBaseline : String -> Command
textBaseline baseline =
    field "textBaseline" (string baseline)



-- Methods


{-| Adds an arc to the path which is centered at (`x`, `y`) position with
`radius` starting at `startAngle` and ending at `endAngle` going in the given
direction by `anticlockwise` (`False` is clockwise). [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/arc)

    empty
        |> beginPath
        |> arc x y radius startAngle endAngle anticlockwise
        |> stroke

-}
arc : Float -> Float -> Float -> Float -> Float -> Bool -> Command
arc x y radius startAngle endAngle anticlockwise =
    fn "arc" [ float x, float y, float radius, float startAngle, float endAngle, bool anticlockwise ]


{-| Adds an arc to the path with the given control points and radius.

The arc drawn will be a part of a circle, never elliptical. Typical use could be
making a rounded corner.

One way to think about the arc drawn is to imagine two straight segments, from
the starting point (latest point in current path) to the first control point,
and then from the first control point to the second control point. These two
segments form a sharp corner with the first control point being in the corner.
Using `arcTo`, the corner will instead be an arc with the given radius.

The arc is tangential to both segments, which can sometimes produce surprising
results, e.g. if the radius given is larger than the distance between the
starting point and the first control point.

If the radius specified doesn't make the arc meet the starting point (latest
point in the current path), the starting point is connected to the arc with
a straight line segment.

    empty |> arcTo x1 y1 x2 y2 radius

[MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/arcTo)

-}
arcTo : Float -> Float -> Float -> Float -> Float -> Command
arcTo x1 y1 x2 y2 radius =
    fn "arcTo" [ float x1, float y1, float x2, float y2, float radius ]


{-| Starts a new path by emptying the list of sub-paths. Call this method when
you want to create a new path. [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/beginPath)
-}
beginPath : Command
beginPath =
    fn "beginPath" []


{-| Adds a cubic Bézier curve to the path. It requires three points. The first
two points are control points and the third one is the end point. The starting
point is the last point in the current path, which can be changed using `moveTo`
before creating the Bézier curve. [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/bezierCurveTo)

    bezierCurveTo cp1x cp1y cp2x cp2y x y

  - `cp1x`
      - The x axis of the coordinate for the first control point.
  - `cp1y`
      - The y axis of the coordinate for the first control point.
  - `cp2x`
      - The x axis of the coordinate for the second control point.
  - `cp2y`
      - The y axis of the coordinate for the second control point.
  - `x`
      - The x axis of the coordinate for the end point.
  - `y`
      - The y axis of the coordinate for the end point.

-}
bezierCurveTo : Float -> Float -> Float -> Float -> Float -> Float -> Command
bezierCurveTo cp1x cp1y cp2x cp2y x y =
    fn "bezierCurveTo" [ float cp1x, float cp1y, float cp2x, float cp2y, float x, float y ]


{-| Sets all pixels in the rectangle defined by starting point (`x`, `y`) and
size (`width`, `height`) to transparent black, erasing any previously drawn
content. [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/clearRect)

    empty |> clearRect x y width height

A common problem with `clearRect` is that it may appear it does not work when
not using paths properly. Don't forget to call `beginPath` before starting to
draw the new frame after calling `clearRect`.

-}
clearRect : Float -> Float -> Float -> Float -> Command
clearRect x y width height =
    fn "clearRect" [ float x, float y, float width, float height ]


{-| Type that represents the algorithm by which to determine if a point is
inside a path or outside a path. If you are not sure, use `NonZero` as it is
the default in the DOM API.

  - `NonZero`: The [non-zero winding rule](http://en.wikipedia.org/wiki/Nonzero-rule).
  - `EvenOdd`: The [even-odd winding rule](http://en.wikipedia.org/wiki/Even%E2%80%93odd_rule).

-}
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


{-| Turns the path currently being built into the current clipping path.
[MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/clip)

Note: Be aware that `clip` only works with shapes added to the path; it doesn't
work with shape primitives such as rectangles created with `fillRect`. In this
case you'd have to use `rect` to draw a rectangular path shape to be clipped.

-}
clip : FillRule -> Command
clip fillRule =
    fn "clip" [ string (fillRuleToString fillRule) ]


{-| Causes the point of the pen to move back to the start of the current
sub-path. It tries to add a straight line (but does not actually draw it) from
the current point to the start. If the shape has already been closed or has
only one point, this function does nothing.
[MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/closePath)

    empty
        |> beginPath
        |> moveTo 20 20
        |> lineTo 200 20
        |> lineTo 120 120
        |> closePath
        -- draws last line of the triangle
        |> stroke

-}
closePath : Command
closePath =
    fn "closePath" []


{-| Fills the current or given path with the current fill style using the
non-zero or even-odd winding rule. See type `FillRule`.
[MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/fill)
-}
fill : FillRule -> Command
fill fillRule =
    fn "fill" [ string (fillRuleToString fillRule) ]


{-| This is a helper non-standard method to trace a circle path. Normally, you'd
need to call `arc` with the correct arguments. This is a convenience function to
easily fill a circle that mirrors `rect`.

    empty |> fillCircle x y radius

-}
circle : Float -> Float -> Float -> Command
circle x y r =
    arc x y r 0 (2 * pi) False


{-| Draws a filled rectangle whose starting point is at the coordinates (`x`, `y`)
with the specified `width` and `height` and whose style is determined by the
fillStyle attribute. [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/fillRect)

    empty |> fillRect x y width height

-}
fillRect : Float -> Float -> Float -> Float -> Command
fillRect x y w h =
    fn "fillRect" [ float x, float y, float w, float h ]


{-| Draws a text string at the specified coordinates, filling the string's
characters with the current foreground color. An optional parameter allows
specifying a maximum width for the rendered text, which the user agent will
achieve by condensing the text or by using a lower font size.

The text is rendered using the font and text layout configuration as defined by
the `font`, `textAlign`, `textBaseline`, and `direction` properties.

To draw the outlines of the characters in a string, call the context's
`strokeText` method.

    empty |> fillText text x y maybeMaxWidth

[MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/fillText)

    empty
        |> font "48px serif"
        |> fillText "Hello world" 50 100 Nothing

-}
fillText : String -> Float -> Float -> Maybe Float -> Command
fillText text x y maybeMaxWidth =
    case maybeMaxWidth of
        Nothing ->
            fn "fillText" [ string text, float x, float y ]

        Just maxWidth ->
            fn "fillText" [ string text, float x, float y, float maxWidth ]


{-| Connects the last point in the sub-path to the x, y coordinates with a
straight line (but does not actually draw it). [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/lineTo)

    empty |> lineTo x y

-}
lineTo : Float -> Float -> Command
lineTo x y =
    fn "lineTo" [ float x, float y ]


{-| Moves the starting point of a new sub-path to the (x, y) coordinates.
[MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/moveTo)

    empty |> moveTo x y

-}
moveTo : Float -> Float -> Command
moveTo x y =
    fn "moveTo" [ float x, float y ]


{-| Adds a quadratic Bézier curve to the path. It requires two points. The
first point is a control point and the second one is the end point. The
starting point is the last point in the current path, which can be changed
using `moveTo` before creating the quadratic Bézier curve. [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/quadraticCurveTo)

    empty |> quadraticCurveTo cpx cpy x y

  - `cpx`
      - The x axis of the coordinate for the control point.
  - `cpy`
      - The y axis of the coordinate for the control point.
  - `x`
      - The x axis of the coordinate for the end point.
  - `y`
      - The y axis of the coordinate for the end point.

-}
quadraticCurveTo : Float -> Float -> Float -> Float -> Command
quadraticCurveTo cpx cpy x y =
    fn "quadraticCurveTo" [ float cpx, float cpy, float x, float y ]


{-| Creates a path for a rectangle at position (`x`, `y`) with a size that is
determined by `width` and `height`. Those four points are connected by straight
lines and the sub-path is marked as closed, so that you can `fill` or `stroke`
this rectangle. [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/rect)

    empty |> rect x y width height

-}
rect : Float -> Float -> Float -> Float -> Command
rect x y w h =
    fn "rect" [ float x, float y, float w, float h ]


{-| Restores the most recently saved canvas state by popping the top entry in
the drawing state stack. If there is no saved state, this method does nothing.
[MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/restore)
-}
restore : Command
restore =
    fn "restore" []


{-| Adds a rotation to the transformation matrix. The `angle` argument
represents a clockwise rotation angle and is expressed in radians.

    empty |> rotate (degrees 90)

The rotation center point is always the canvas origin. To change the center
point, we will need to move the canvas by using the `translate` method.

[MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/rotate)

-}
rotate : Float -> Command
rotate angle =
    fn "rotate" [ float angle ]


{-| Saves the entire state of the canvas by pushing the current state onto
a stack. [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/save)

The drawing state that gets saved onto a stack consists of:

  - The current transformation matrix.
  - The current clipping region.
  - The current dash list.
  - The current values of the following attributes: strokeStyle, fillStyle, globalAlpha, lineWidth, lineCap, lineJoin, miterLimit, lineDashOffset, shadowOffsetX, shadowOffsetY, shadowBlur, shadowColor, globalCompositeOperation, font, textAlign, textBaseline, direction, imageSmoothingEnabled.

-}
save : Command
save =
    fn "save" []


{-| Adds a scaling transformation to the canvas units by x horizontally and by
y vertically.

By default, one unit on the canvas is exactly one pixel. If we apply, for
instance, a scaling factor of 0.5, the resulting unit would become 0.5 pixels
and so shapes would be drawn at half size. In a similar way setting the scaling
factor to 2.0 would increase the unit size and one unit now becomes two pixels.
This results in shapes being drawn twice as large.

    empty |> scale x y

  - `x`
      - Scaling factor in the horizontal direction.
  - `y`
      - Scaling factor in the vertical direction.

Note: You can use `scale -1 1` to flip the context horizontally and `scale 1
-1` to flip it vertically.

[MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/scale)

-}
scale : Float -> Float -> Command
scale x y =
    fn "scale" [ float x, float y ]


{-| Sets the line dash pattern used when stroking lines, using an array of
values which specify alternating lengths of lines and gaps which describe the
pattern.

To return to using solid lines, set the line dash list to an empty array.

    empty |> setLineDash segments

  - `segments`
      - An Array of numbers which specify distances to alternately draw a line
        and a gap (in coordinate space units). If the number of elements in the array
        is odd, the elements of the array get copied and concatenated. For example, `[5,
        15, 25]` will become `[5, 15, 25, 5, 15, 25]`. If the array is empty, the line
        dash list is cleared and line strokes return to being solid.

[MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/setLineDash)

-}
setLineDash : List Float -> Command
setLineDash segments =
    fn "setLineDash" [ Encode.list float segments ]


{-| Resets (overrides) the current transformation to the identity matrix and
then invokes a transformation described by the arguments of this method.

See also the `transform` method, which does not override the current transform
matrix and multiplies it with a given one.

    empty |> setTransform a b c d e f

  - `a` (m11)
      - Horizontal scaling.
  - `b` (m12)
      - Horizontal skewing.
  - `c` (m21)
      - Vertical skewing.
  - `d` (m22)
      - Vertical scaling.
  - `e` (dx)
      - Horizontal moving.
  - `f` (dy)
      - Vertical moving.

[MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/setTransform)

-}
setTransform : Float -> Float -> Float -> Float -> Float -> Float -> Command
setTransform a b c d e f =
    fn "setTransform" [ float a, float b, float c, float d, float e, float f ]


{-| Strokes the current or given path with the current stroke style using the
non-zero winding rule. [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/stroke)
-}
stroke : Command
stroke =
    fn "stroke" []


{-| Paints a rectangle which has a starting point at (`x`, `y`) and has a `width`
and an `height` onto the canvas, using the current stroke style. [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/strokeRect)

    empty |> strokeRect x y width height

-}
strokeRect : Float -> Float -> Float -> Float -> Command
strokeRect x y w h =
    fn "strokeRect" [ float x, float y, float w, float h ]


{-| Strokes — that is, draws the outlines of — the characters of a specified
text string at the given (`x`, `y`) position. If the optional fourth parameter
for a maximum width is provided, the text is scaled to fit that width.

See the `fillText` method to draw the text with the characters filled with
color rather than having just their outlines drawn.

    empty |> strokeText text x y maybeMaxWidth

[MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/strokeText)

    empty |> strokeText "Hello world" 40 50 (Just 100)

-}
strokeText : String -> Float -> Float -> Maybe Float -> Command
strokeText text x y maybeMaxWidth =
    case maybeMaxWidth of
        Nothing ->
            fn "strokeText" [ string text, float x, float y ]

        Just maxWidth ->
            fn "strokeText" [ string text, float x, float y, float maxWidth ]


{-| Multiplies the current transformation with the matrix described by the
arguments of this method. You are able to scale, rotate, move and skew the
context.

See also the `setTransform` method which resets the current transform to the
identity matrix and then invokes `transform`.

    empty |> transform a b c d e f

  - `a` (m11)
      - Horizontal scaling.
  - `b` (m12)
      - Horizontal skewing.
  - `c` (m21)
      - Vertical skewing.
  - `d` (m22)
      - Vertical scaling.
  - `e` (dx)
      - Horizontal moving.
  - `f` (dy)
      - Vertical moving.

[MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/transform)

-}
transform : Float -> Float -> Float -> Float -> Float -> Float -> Command
transform a b c d e f =
    fn "transform" [ float a, float b, float c, float d, float e, float f ]


{-| Adds a translation transformation by moving the canvas and its origin `x`
horizontally and `y` vertically on the grid. [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/translate)

    empty |> translate x y

-}
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


commands : Commands -> Attribute msg
commands list =
    list
        |> Encode.list identity
        |> property "cmds"


field : String -> Command -> Command
field name value =
    Encode.object [ ( "type", string "field" ), ( "name", string name ), ( "value", value ) ]


fn : String -> List Command -> Command
fn name args =
    Encode.object [ ( "type", string "function" ), ( "name", string name ), ( "args", Encode.list identity args ) ]


addTo : Commands -> Command -> Commands
addTo list cmd =
    cmd :: list



-- Helpers


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
