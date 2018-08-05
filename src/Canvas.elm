module Canvas
    exposing
        ( Commands
        , empty
        , element
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
        , strokeCircle
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


# Usage in HTML

@docs element


# Composing Commands

@docs Commands, empty


# Colors

@docs fillStyle, strokeStyle


# Text

@docs font, TextAlign, textAlign, TextBaseLine, textBaseline, fillText, strokeText


# Shapes

@docs fillRect, strokeRect, clearRect, fillCircle, strokeCircle


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


{-| Represents commands to execute on the DOM canvas. You build commands with
the helper functions the library exposes, which mirror the canvas API.

Then, you pass the commands to the `element` you render on the view, and they
will be run!

-}
type Commands
    = Commands (List Command)


type alias Command =
    Encode.Value


{-| Create an empty set of commands to start working with.

    Canvas.empty
        |> Canvas.clearScreen
        |> Canvas.fillStyle (Color.rgba 0 0 0 1)
        |> Canvas.fillRect 0 0 40 50

-}
empty : Commands
empty =
    Commands []



-- HTML


{-| Create a Html element that you can use in your view.

    view : Model -> Html Msg
    view { isRunning, time } =
        Canvas.element
            width
            height
            [ onClick ToggleRunning ]
            (Canvas.empty
                |> Canvas.clearScreen
                |> Canvas.fillStyle (Color.rgba 0 0 0 1)
                |> Canvas.fillRect 0 0 40 50
            )

-}
element : Int -> Int -> List (Attribute msg) -> Commands -> Html msg
element w h attrs cmds =
    Html.node "elm-canvas"
        [ commands cmds ]
        [ canvas (List.concat [ [ height h, width w ], attrs ]) []
        ]



-- Properties


{-| Specifies the color or style to use inside shapes. The default is #000
(black). [MDN Docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/fillStyle)

    empty |> fillStyle (Color.rgba 125 200 255 0.6)

-}
fillStyle : Color -> Commands -> Commands
fillStyle color cmds =
    color
        |> colorToCSSString
        |> string
        |> field "fillStyle"
        |> addTo cmds


{-| Specifies the current text style being used when drawing text. This string
uses the same syntax as the [CSS
font](https://developer.mozilla.org/en-US/docs/Web/CSS/font) specifier. The
default font is 10px sans-serif. [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/font)

    empty
    |> font "48px serif"
    |> strokeText "Hello world" 50 100

-}
font : String -> Commands -> Commands
font f cmds =
    field "font" (string f)
        |> addTo cmds


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
globalAlpha : Float -> Commands -> Commands
globalAlpha alpha cmds =
    field "globalAlpha" (float alpha)
        |> addTo cmds


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

    empty |> globalCompositeOperation Screen

-}
globalCompositeOperation : GlobalCompositeOperationMode -> Commands -> Commands
globalCompositeOperation mode cmds =
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
        field "globalCompositeOperation" (string stringMode)
            |> addTo cmds


{-| Type of end points for line drawn.

  - `ButtCap`
      - The ends of lines are squared off at the endpoints.
  - `RoundCap`
      - The ends of lines are rounded.
  - `SquareCap`
      - The ends of lines are squared off by adding a box with an equal width
        and half the height of the line's thickness.

-}
type LineCap
    = ButtCap
    | RoundCap
    | SquareCap


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
lineCap : LineCap -> Commands -> Commands
lineCap cap cmds =
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
        |> addTo cmds


{-| Sets the line dash pattern offset or "phase". [MDN
docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/lineDashOffset)

    empty
    |> setLineDash [4, 16]
    |> lineDashOffset 2
    |> beginPath
    |> moveTo 0 100
    |> lineTo 400 100
    |> stroke

-}
lineDashOffset : Float -> Commands -> Commands
lineDashOffset value cmds =
    field "lineDashOffset" (float value)
        |> addTo cmds


{-| Determines how two connecting segments with non-zero lengths in a shape are
joined together. [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/lineJoin)

  - `Round`
      - Rounds off the corners of a shape by filling an additional sector of disc
        centered at the common endpoint of connected segments. The radius for these
        rounded corners is equal to the line width.
  - `Bevel`
      - Fills an additional triangular area between the common endpoint of
        connected segments, and the separate outside rectangular corners of each segment.
  - `Miter`
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

    empty
    |> lineWidth 10
    |> lineJoin RoundJoin
    |> beginPath
    |> moveTo 0 0
    |> lineTo 200 100
    |> lineTo 300 0
    |> stroke

-}
lineJoin : LineJoin -> Commands -> Commands
lineJoin join cmds =
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
        |> addTo cmds


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
lineWidth : Float -> Commands -> Commands
lineWidth value cmds =
    field "lineWidth" (float value)
        |> addTo cmds


{-| Sets the miter limit ratio in space units. When setting, zero, negative,
Infinity and NaN values are ignored; otherwise the current value is set to the
new value. [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/miterLimit)
-}
miterLimit : Float -> Commands -> Commands
miterLimit value cmds =
    field "miterLimit" (float value)
        |> addTo cmds


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
shadowBlur : Float -> Commands -> Commands
shadowBlur value cmds =
    field "shadowBlur" (float value)
        |> addTo cmds


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
shadowColor : Color -> Commands -> Commands
shadowColor color cmds =
    color
        |> colorToCSSString
        |> string
        |> field "shadowColor"
        |> addTo cmds


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
shadowOffsetX : Float -> Commands -> Commands
shadowOffsetX value cmds =
    field "shadowOffsetX" (float value)
        |> addTo cmds


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
shadowOffsetY : Float -> Commands -> Commands
shadowOffsetY value cmds =
    field "shadowOffsetY" (float value)
        |> addTo cmds


{-| Specifies the color or style to use for the lines around shapes. The default
is #000 (black). [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/strokeStyle)

    empty
    |> strokeStyle (Color.rgb 0 0 255)
    |> strokeRect 10 10 100 100

-}
strokeStyle : Color -> Commands -> Commands
strokeStyle color cmds =
    {- TODO: support CanvasGradient and CanvasPattern -}
    color
        |> colorToCSSString
        |> string
        |> field "strokeStyle"
        |> addTo cmds


{-| Type of text alignment

  - `Left`
      - The text is left-aligned.
  - `Right`
      - The text is right-aligned.
  - `Center`
      - The text is centered.
  - `Start`
      - The text is aligned at the normal start of the line (left-aligned for
        left-to-right locales, right-aligned for right-to-left locales).
  - `End`
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

    empty
    |> font "48px serif"
    |> textAlign Left
    |> strokeText "Hello world" 0 100

-}
textAlign : TextAlign -> Commands -> Commands
textAlign align cmds =
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
        |> addTo cmds


{-| Type of text baseline.

  - `Top`
      - The text baseline is the top of the em square.
  - `Hanging`
      - The text baseline is the hanging baseline. (Used by Tibetan and other Indic scripts.)
  - `Middle`
      - The text baseline is the middle of the em square.
  - `Alphabetic`
      - The text baseline is the normal alphabetic baseline.
  - `Ideographic`
      - The text baseline is the ideographic baseline; this is the bottom of the body of the characters, if the main body of characters protrudes beneath the alphabetic baseline. (Used by Chinese, Japanese and Korean scripts.)
  - `Bottom`
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

The default value is `Alphabetic`.

See [MDN
docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/textBaseline)
for examples and rendering of the different modes.

-}
textBaseline : TextBaseLine -> Commands -> Commands
textBaseline baseline cmds =
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
        |> addTo cmds



-- Methods


{-| Adds an arc to the path which is centered at (`x`, `y`) position with
`radius` starting at `startAngle` and ending at `endAngle` going in the given
direction by `anticlockwise` (`False` is clockwise). [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/arc)

    empty
    |> beginPath
    |> arc x y radius startAngle endAngle anticlockwise
    |> stroke

-}
arc : Float -> Float -> Float -> Float -> Float -> Bool -> Commands -> Commands
arc x y radius startAngle endAngle anticlockwise cmds =
    fn "arc" [ float x, float y, float radius, float 0, float (2 * pi), bool anticlockwise ]
        |> addTo cmds


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
arcTo : Float -> Float -> Float -> Float -> Float -> Commands -> Commands
arcTo x1 y1 x2 y2 radius cmds =
    fn "arcTo" [ float x1, float y1, float x2, float y2, float radius ]
        |> addTo cmds


{-| Starts a new path by emptying the list of sub-paths. Call this method when
you want to create a new path. [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/beginPath)
-}
beginPath : Commands -> Commands
beginPath cmds =
    fn "beginPath" []
        |> addTo cmds


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
bezierCurveTo : Float -> Float -> Float -> Float -> Float -> Float -> Commands -> Commands
bezierCurveTo cp1x cp1y cp2x cp2y x y cmds =
    fn "bezierCurveTo" [ float cp1x, float cp1y, float cp2x, float cp2y, float x, float y ]
        |> addTo cmds


{-| Sets all pixels in the rectangle defined by starting point (`x`, `y`) and
size (`width`, `height`) to transparent black, erasing any previously drawn
content. [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/clearRect)

    empty |> clearRect x y width height

A common problem with `clearRect` is that it may appear it does not work when
not using paths properly. Don't forget to call `beginPath` before starting to
draw the new frame after calling `clearRect`.

-}
clearRect : Float -> Float -> Float -> Float -> Commands -> Commands
clearRect x y width height cmds =
    fn "clearRect" [ float x, float y, float width, float height ]
        |> addTo cmds


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
clip : FillRule -> Commands -> Commands
clip fillRule cmds =
    fn "clip" [ string (fillRuleToString fillRule) ]
        |> addTo cmds


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
    |> closePath -- draws last line of the triangle
    |> stroke

-}
closePath : Commands -> Commands
closePath cmds =
    fn "closePath" []
        |> addTo cmds


{-| Fills the current or given path with the current fill style using the
non-zero or even-odd winding rule. See type `FillRule`.
[MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/fill)
-}
fill : FillRule -> Commands -> Commands
fill fillRule cmds =
    fn "fill" [ string (fillRuleToString fillRule) ]
        |> addTo cmds


{-| This is a helper non-standard method to fill a circle. Normally, you'd
need to call `beginPath`, `arc` with the correct arguments, and `fill`. This is
a convenience function to easily fill a circle that mirrors `fillRect`.

    empty |> fillCircle x y radius

-}
fillCircle : Float -> Float -> Float -> Commands -> Commands
fillCircle x y r cmds =
    cmds
        |> beginPath
        |> arc x y r 0 (2 * pi) False
        |> fill NonZero


{-| This is a helper non-standard method to stroke a circle. Normally, you'd
need to call `beginPath`, `arc` with the correct arguments, and `stroke`. This
is a convenience function to easily fill a circle that mirrors `strokeRect`.

    empty |> strokeCircle x y radius

-}
strokeCircle : Float -> Float -> Float -> Commands -> Commands
strokeCircle x y r cmds =
    cmds
        |> beginPath
        |> arc x y r 0 (2 * pi) False
        |> stroke


{-| Draws a filled rectangle whose starting point is at the coordinates (`x`, `y`)
with the specified `width` and `height` and whose style is determined by the
fillStyle attribute. [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/fillRect)

    empty |> fillRect x y width height

-}
fillRect : Float -> Float -> Float -> Float -> Commands -> Commands
fillRect x y w h cmds =
    fn "fillRect" [ float x, float y, float w, float h ]
        |> addTo cmds


{-| Draws a text string at the specified coordinates, filling the string's
characters with the current foreground color. An optional parameter allows
specifying a maximum width for the rendered text, which the user agent will
achieve by condensing the text or by using a lower font size.

The text is rendered using the font and text layout configuration as defined by
the `font`, `textAlign`, `textBaseline`, and `direction` properties.

To draw the outlines of the characters in a string, call the context's
`strokeText` method.

    empty |> fillText text x y maxWidth

[MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/fillText)

    empty
    |> font "48px serif"
    |> fillText "Hello world" 50 100 Nothing

-}
fillText : String -> Float -> Float -> Maybe Float -> Commands -> Commands
fillText text x y maxWidth cmds =
    (case maxWidth of
        Nothing ->
            fn "fillText" [ string text, float x, float y ]

        Just maxWidth ->
            fn "fillText" [ string text, float x, float y, float maxWidth ]
    )
        |> addTo cmds


{-| Connects the last point in the sub-path to the x, y coordinates with a
straight line (but does not actually draw it). [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/lineTo)

    empty |> lineTo x y

-}
lineTo : Float -> Float -> Commands -> Commands
lineTo x y cmds =
    fn "lineTo" [ float x, float y ]
        |> addTo cmds


{-| Moves the starting point of a new sub-path to the (x, y) coordinates.
[MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/moveTo)

    empty |> moveTo x y

-}
moveTo : Float -> Float -> Commands -> Commands
moveTo x y cmds =
    fn "moveTo" [ float x, float y ]
        |> addTo cmds


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
quadraticCurveTo : Float -> Float -> Float -> Float -> Commands -> Commands
quadraticCurveTo cpx cpy x y cmds =
    fn "quadraticCurveTo" [ float cpx, float cpy, float x, float y ]
        |> addTo cmds


{-| Creates a path for a rectangle at position (`x`, `y`) with a size that is
determined by `width` and `height`. Those four points are connected by straight
lines and the sub-path is marked as closed, so that you can `fill` or `stroke`
this rectangle. [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/rect)

    empty |> rect x y width height

-}
rect : Float -> Float -> Float -> Float -> Commands -> Commands
rect x y w h cmds =
    fn "rect" [ float x, float y, float w, float h ]
        |> addTo cmds


{-| Restores the most recently saved canvas state by popping the top entry in
the drawing state stack. If there is no saved state, this method does nothing.
[MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/restore)
-}
restore : Commands -> Commands
restore cmds =
    fn "restore" []
        |> addTo cmds


{-| Adds a rotation to the transformation matrix. The `angle` argument
represents a clockwise rotation angle and is expressed in radians.

    empty |> rotate (degrees 90)

The rotation center point is always the canvas origin. To change the center
point, we will need to move the canvas by using the `translate` method.

[MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/rotate)

-}
rotate : Float -> Commands -> Commands
rotate angle cmds =
    fn "rotate" [ float angle ]
        |> addTo cmds


{-| Saves the entire state of the canvas by pushing the current state onto
a stack. [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/save)

The drawing state that gets saved onto a stack consists of:

  - The current transformation matrix.
  - The current clipping region.
  - The current dash list.
  - The current values of the following attributes: strokeStyle, fillStyle, globalAlpha, lineWidth, lineCap, lineJoin, miterLimit, lineDashOffset, shadowOffsetX, shadowOffsetY, shadowBlur, shadowColor, globalCompositeOperation, font, textAlign, textBaseline, direction, imageSmoothingEnabled.

-}
save : Commands -> Commands
save cmds =
    fn "save" []
        |> addTo cmds


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
scale : Float -> Float -> Commands -> Commands
scale x y cmds =
    fn "scale" [ float x, float y ]
        |> addTo cmds


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
setLineDash : List Float -> Commands -> Commands
setLineDash segments cmds =
    fn "setLineDash" [ Encode.list (List.map float segments) ]
        |> addTo cmds


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
setTransform : Float -> Float -> Float -> Float -> Float -> Float -> Commands -> Commands
setTransform a b c d e f cmds =
    fn "setTransform" [ float a, float b, float c, float d, float e, float f ]
        |> addTo cmds


{-| Strokes the current or given path with the current stroke style using the
non-zero winding rule. [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/stroke)
-}
stroke : Commands -> Commands
stroke cmds =
    fn "stroke" []
        |> addTo cmds


{-| Paints a rectangle which has a starting point at (`x`, `y`) and has a `width`
and an `height` onto the canvas, using the current stroke style. [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/strokeRect)

    empty |> strokeRect x y width height

-}
strokeRect : Float -> Float -> Float -> Float -> Commands -> Commands
strokeRect x y w h cmds =
    fn "strokeRect" [ float x, float y, float w, float h ]
        |> addTo cmds


{-| Strokes — that is, draws the outlines of — the characters of a specified
text string at the given (`x`, `y`) position. If the optional fourth parameter
for a maximum width is provided, the text is scaled to fit that width.

See the `fillText` method to draw the text with the characters filled with
color rather than having just their outlines drawn.

    empty |> strokeText text x y maxWidth

[MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/strokeText)

    empty |> strokeText "Hello world" 40 50 (Just 100)

-}
strokeText : String -> Float -> Float -> Maybe Float -> Commands -> Commands
strokeText text x y maxWidth cmds =
    (case maxWidth of
        Nothing ->
            fn "strokeText" [ string text, float x, float y ]

        Just maxWidth ->
            fn "strokeText" [ string text, float x, float y, float maxWidth ]
    )
        |> addTo cmds


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
transform : Float -> Float -> Float -> Float -> Float -> Float -> Commands -> Commands
transform a b c d e f cmds =
    fn "transform" [ float a, float b, float c, float d, float e, float f ]
        |> addTo cmds


{-| Adds a translation transformation by moving the canvas and its origin `x`
horizontally and `y` vertically on the grid. [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/translate)

    empty |> translate x y

-}
translate : Float -> Float -> Commands -> Commands
translate x y cmds =
    fn "translate" [ float x, float y ]
        |> addTo cmds



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
commands (Commands list) =
    list
        |> Encode.list
        |> property "cmds"


field : String -> Command -> Command
field name value =
    Encode.object [ ( "type", string "field" ), ( "name", string name ), ( "value", value ) ]


fn : String -> List Command -> Command
fn name args =
    Encode.object [ ( "type", string "function" ), ( "name", string name ), ( "args", Encode.list args ) ]


addTo : Commands -> Command -> Commands
addTo (Commands list) cmd =
    Commands (cmd :: list)


batch : Commands -> Commands -> Commands
batch (Commands list1) (Commands total) =
    Commands (List.concat [ list1, total ])



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
