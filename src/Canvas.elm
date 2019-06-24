module Canvas exposing
    ( toHtml, toHtmlWith
    , Renderable, Setting
    , shapes, text, texture
    , Point
    , fill, stroke
    , Shape
    , rect, circle, arc, path
    , PathSegment, arcTo, bezierCurveTo, lineTo, moveTo, quadraticCurveTo
    , font, align, TextAlign(..), baseLine, TextBaseLine(..)
    , lineWidth, lineCap, LineCap(..), lineJoin, LineJoin(..), lineDash, lineDashOffset, miterLimit
    , shadow, Shadow
    , transform, Transform, translate, rotate, scale, applyMatrix
    , alpha, compositeOperationMode, GlobalCompositeOperationMode(..)
    )

{-| This module exposes a nice drawing API that works on top of the the DOM
canvas.

See instructions in the main page of the package for installation, as it
requires the `elm-canvas` web component to work.


# Usage in HTML

@docs toHtml, toHtmlWith


# Drawing things

@docs Renderable, Setting

@docs shapes, text, texture

@docs Point


# Styling the things you draw

The two main style settings are fill color and stroke color, which are
documented here.

@docs fill, stroke

There are other style settings in the documentation (if you search for things
that return a `Setting` you can see). More specifically:

  - There are some style settings that only apply when drawing text, and you can find them in the **Drawing text** section.
  - There are other more advanced rendering settings that you can read about
    further down in the **Advanced rendering settings** section. They cover things
    like:
      - Line settings that apply to paths and shapes and text with stroke.
      - Shadows.
      - Matrix transforms.
      - And other more advanced topics like compositing mode.


# Drawing shapes

Shapes can be rectangles, circles, and different types of lines. By composing
shapes, you can draw complex figures! There are many functions that produce
a `Shape`, which you can feed to `shapes` to get something on the screen.

@docs Shape

Here are the different functions that produce shapes that we can draw.

@docs rect, circle, arc, path


## Paths

In order to make a complex path, we need to put together a list of `PathSegment`

@docs PathSegment, arcTo, bezierCurveTo, lineTo, moveTo, quadraticCurveTo


# Drawing text

To draw text we use the function `text` documented above:

    text
        [ font { size = 48, family = "serif" }
        , align Center
        ]
        ( 50, 50 )
        "Hello world"

You can apply the following styling settings to text specifically. They will do
nothing if you apply them to other renderables, like `shapes`.

@docs font, align, TextAlign, baseLine, TextBaseLine


# Advanced rendering settings

The following are settings that you can apply, to create very specific and
custom effects.


## Line settings

Line style settings apply to paths, and the stroke of shapes and text (if any).

@docs lineWidth, lineCap, LineCap, lineJoin, LineJoin, lineDash, lineDashOffset, miterLimit


## Shadows

The shadow setting allows you to create a shadow for a renderable, similar to
what the `box-shadow` CSS does to HTML elements.

@docs shadow, Shadow


## Transforms: scaling, rotating, translating, and matrix transformations

Transforms are very useful as they allow you to manipulate the rendering via
a transformation matrix, allowing you to translate, scale, rotate and skew the
rendering context easily. They can be a bit of an advanced topic, but they are
powerful and can be very useful.

@docs transform, Transform, translate, rotate, scale, applyMatrix


## Alpha and global composite mode

Finally, there are a couple of other settings that you can use to create
interesting visual effects:

@docs alpha, compositeOperationMode, GlobalCompositeOperationMode

-}

import Canvas.Internal as I exposing (Commands, commands)
import Canvas.InternalTexture as TI
import Canvas.Texture as Texture exposing (Texture)
import Color exposing (Color)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on)
import Html.Keyed as Keyed
import Json.Decode as D



-- HTML


{-| Create a Html element that you can use in your view.

    Canvas.toHtml ( width, height )
        [ onClick CanvasClick ]
        [ shapes [ fill Color.white ] [ rect ( 0, 0 ) w h ]
        , text [ size 48, align Center ] ( 50, 50 ) "Hello world"
        ]

`toHtml` is almost like creating other Html elements. We need to pass `(width,
height)` in pixels, a list of `Html.Attribute`, and finally _instead_ of a list
of html elements, we pass a `List Renderable`. A `Renderable` is a thing that
the canvas knows how to render. Read on for more information 👇.

**Note**: Remember to include the `elm-canvas` web component from npm in your page for
this to work!

-}
toHtml : ( Int, Int ) -> List (Attribute msg) -> List Renderable -> Html msg
toHtml ( w, h ) attrs entities =
    Html.node "elm-canvas"
        [ commands (render entities), height h, width w ]
        [ canvas (height h :: width w :: attrs) []
        ]


{-| Similar to `toHtml` but with more explicit options and the ability to load
textures.

    Canvas.toHtmlWith
        { width = 500
        , height = 500
        , textures = [ Texture.loadImageUrl "./assets/sprite.png" TextureLoaded ]
        }
        [ onClick CanvasClick ]
        [ shapes [ fill Color.white ] [ rect ( 0, 0 ) w h ]
        , text [ size 48, align Center ] ( 50, 50 ) "Hello world"
        ]

**Note**: Remember to include the `elm-canvas` web component from npm in your page for
this to work!

See `toHtml` above and the `Canvas.Texture` module for more details.

-}
toHtmlWith :
    { width : Int
    , height : Int
    , textures : List (Texture.Source msg)
    }
    -> List (Attribute msg)
    -> List Renderable
    -> Html msg
toHtmlWith options attrs entities =
    Keyed.node "elm-canvas"
        [ commands (render entities), height options.height, width options.width ]
        (( "__canvas", canvas (height options.height :: width options.height :: attrs) [] )
            :: List.map renderTextureSource options.textures
        )



-- Types


{-| A small alias to reference points on some of the functions on the package.

The first argument of the tuple is the `x` position, and the second is the `y`
position.

    -- Making a point with x = 15 and y = 55
    point : Point
    point =
        ( 15, 55 )

-}
type alias Point =
    ( Float, Float )


{-| A `Renderable` is a thing that the canvas knows how to render, similar to
`Html` elements.

We can make `Renderable`s to use with `Canvas.toHtml` with functions like
`shapes` and `text`.

-}
type Renderable
    = Renderable
        { commands : I.Commands
        , drawOp : DrawOp
        , drawable : Drawable
        }


type Drawable
    = DrawableText Text
    | DrawableShapes (List Shape)
    | DrawableTexture Point Texture


type DrawOp
    = NotSpecified
    | Fill Color
    | Stroke Color
    | FillAndStroke Color Color


{-| Similar to `Html.Attribute`, settings control the presentation and other
style options for the `Renderable`s.
-}
type Setting
    = SettingCommand I.Command
    | SettingCommands I.Commands
    | SettingDrawOp DrawOp
    | SettingUpdateDrawable (Drawable -> Drawable)


{-| By default, renderables are drawn with black color. If you want to specify
a different color to draw, use this `Setting` on your renderable.

The type `Color` comes from the package `avh4/elm-color`. To use it explicitly,
run:

    elm install avh4 / elm - color

and then import it in.

    import Color
    -- ...
    shapes
        [ fill Color.green ]
        [ rect ( 10, 30 ) 50 50 ]

-}
fill : Color -> Setting
fill color =
    SettingDrawOp (Fill color)


mergeDrawOp : DrawOp -> DrawOp -> DrawOp
mergeDrawOp op1 op2 =
    case ( op1, op2 ) of
        ( Fill _, Fill c ) ->
            Fill c

        ( Stroke _, Stroke c ) ->
            Stroke c

        ( Fill c1, Stroke c2 ) ->
            FillAndStroke c1 c2

        ( Stroke c1, Fill c2 ) ->
            FillAndStroke c2 c1

        ( _, FillAndStroke c sc ) ->
            FillAndStroke c sc

        ( FillAndStroke c sc, Fill c2 ) ->
            FillAndStroke c2 sc

        ( FillAndStroke c sc, Stroke sc2 ) ->
            FillAndStroke c sc2

        ( NotSpecified, whatever ) ->
            whatever

        ( whatever, NotSpecified ) ->
            whatever


{-| By default, renderables are drawn with no visible stroke. If you want to
specify a stroke color to draw an outline over your renderable, use this
`Setting` on it.

The type `Color` comes from the package `avh4/elm-color`. To use it explicitly,
run:

    elm install avh4 / elm - color

and then import it in.

    import Color
    -- ...
    shapes
        [ stroke Color.red ]
        [ rect ( 10, 30 ) 50 50 ]

-}
stroke : Color -> Setting
stroke color =
    SettingDrawOp
        (Stroke color)



-- Shapes drawables


{-| A `Shape` represents a shape or lines to be drawn. Giving them to `shapes`
we get a `Renderable` for the canvas.

    shapes []
        [ path ( 20, 10 )
            [ lineTo ( 10, 30 )
            , lineTo ( 30, 30 )
            , lineTo ( 20, 10 )
            ]
        , circle ( 50, 50 ) 10
        , rect ( 100, 150 ) 40 50
        , circle ( 100, 100 ) 80
        ]

-}
type Shape
    = Rect Point Float Float
    | Circle Point Float
    | Path Point (List PathSegment)
    | Arc Point Float Float Float Bool


{-| In order to draw a path, you need to give the function `path` a list of
`PathSegment`
-}
type PathSegment
    = ArcTo Point Point Float
    | BezierCurveTo Point Point Point
    | LineTo Point
    | MoveTo Point
    | QuadraticCurveTo Point Point


{-| We use `shapes` to render different shapes like rectangles, circles, and
lines of different kinds that we can connect together.

You can draw many shapes with the same `Setting`s, which makes for very
efficient rendering.

    import Canvas exposing (..)
    import Color -- elm install avh4/elm-color

    Canvas.toHtml ( width, height )
        []
        [ shapes [ fill Color.white ] [ rect ( 0, 0 ) width height ] ]

You can read more about the different kinds of `Shape` in the **Drawing shapes**
section.

-}
shapes : List Setting -> List Shape -> Renderable
shapes settings ss =
    addSettingsToRenderable settings
        (Renderable
            { commands = []
            , drawOp = NotSpecified
            , drawable = DrawableShapes ss
            }
        )


addSettingsToRenderable : List Setting -> Renderable -> Renderable
addSettingsToRenderable settings renderable =
    let
        addSetting : Setting -> Renderable -> Renderable
        addSetting setting (Renderable r) =
            Renderable <|
                case setting of
                    SettingCommand cmd ->
                        { r | commands = cmd :: r.commands }

                    SettingCommands cmds ->
                        { r | commands = List.foldl (::) r.commands cmds }

                    SettingUpdateDrawable f ->
                        { r | drawable = f r.drawable }

                    SettingDrawOp op ->
                        { r | drawOp = mergeDrawOp r.drawOp op }
    in
    List.foldl addSetting renderable settings


{-| Creates the shape of a rectangle. It needs the position of the top left
corner, the width, and the height.

    rect pos width height

-}
rect : Point -> Float -> Float -> Shape
rect pos width height =
    Rect pos width height


{-| Creates a circle. It takes the position of the center of the circle, and the
radius of it.

    circle pos radius

-}
circle : Point -> Float -> Shape
circle pos radius =
    Circle pos radius


{-| Creates a complex path as a shape from a list of `PathSegment` instructions.

It is mandatory to pass in the starting point for the path, since the path
starts with an implicit `moveTo` the starting point to avoid undesirable
behavior and implicit state.

    path startingPoint segments

-}
path : Point -> List PathSegment -> Shape
path startingPoint segments =
    Path startingPoint segments


{-| Creates an arc, a partial circle. It takes the position of the center of the
circle, the radius of it, the start angle where the arc will start, the end
angle where the arc will end, and if it should draw in clockwise or
anti-clockwise direction.

    arc ( 10, 10 ) 40 { startAngle = 15, endAngle = 85, clockwise = True }

-}
arc : Point -> Float -> { startAngle : Float, endAngle : Float, clockwise : Bool } -> Shape
arc pos radius { startAngle, endAngle, clockwise } =
    Arc pos radius startAngle endAngle (not clockwise)


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

    arcTo ( x1, y1 ) ( x2, y2 ) radius

You can see more examples and docs in [this page](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/arcTo)

-}
arcTo : Point -> Point -> Float -> PathSegment
arcTo pos1 pos2 radius =
    ArcTo pos1 pos2 radius


{-| Adds a cubic Bézier curve to the path. It requires three points. The first
two points are control points and the third one is the end point. The starting
point is the last point in the current path, which can be changed using `moveTo`
before creating the Bézier curve. You can learn more about this curve in the
[MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/bezierCurveTo).

    bezierCurveTo controlPoint1 controlPoint2 point

    bezierCurveTo ( cp1x, cp1y ) ( cp2x, cp2y ) ( x, y )

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
bezierCurveTo : Point -> Point -> Point -> PathSegment
bezierCurveTo controlPoint1 controlPoint2 point =
    BezierCurveTo controlPoint1 controlPoint2 point


{-| Connects the last point in the previous shape to the x, y coordinates with a
straight line.

    lineTo ( x, y )

If you want to make a line independently of where the previous shape ended, you
can use `moveTo` before using lineTo.

-}
lineTo : Point -> PathSegment
lineTo point =
    LineTo point


{-| `moveTo` doesn't necessarily produce any shape, but it moves the starting
point somewhere so that you can use this with other lines.

    moveTo point

-}
moveTo : Point -> PathSegment
moveTo point =
    MoveTo point


{-| Adds a quadratic Bézier curve to the path. It requires two points. The
first point is a control point and the second one is the end point. The starting
point is the last point in the current path, which can be changed using `moveTo`
before creating the quadratic Bézier curve. Learn more about quadratic bezier
curves in the [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/quadraticCurveTo)

    quadraticCurveTo controlPoint point

    quadraticCurveTo ( cpx, cpy ) ( x, y )

  - `cpx`
      - The x axis of the coordinate for the control point.
  - `cpy`
      - The y axis of the coordinate for the control point.
  - `x`
      - The x axis of the coordinate for the end point.
  - `y`
      - The y axis of the coordinate for the end point.

-}
quadraticCurveTo : Point -> Point -> PathSegment
quadraticCurveTo controlPoint point =
    QuadraticCurveTo controlPoint point



-- Text drawables


{-| To render text, we need to create with `text`
-}
type alias Text =
    { maxWidth : Maybe Float, point : Point, text : String }


{-| We use `text` to render text on the canvas. We need to pass the list of
settings to style it, the point with the coordinates where we want to render,
and the text to render.

Keep in mind that `align` and other settings can change where the text is
positioned with regards to the coordinates provided.

    Canvas.toHtml ( width, height )
        []
        [ text [ size 48, align Center ] ( 50, 50 ) "Hello world" ]

You can learn more about drawing text and its settings in the **Drawing text**
section.

-}
text : List Setting -> Point -> String -> Renderable
text settings point str =
    addSettingsToRenderable settings
        (Renderable
            { commands = []
            , drawOp = NotSpecified
            , drawable = DrawableText { maxWidth = Nothing, point = point, text = str }
            }
        )


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


textAlignToString alignment =
    case alignment of
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


textBaseLineToString baseLineSetting =
    case baseLineSetting of
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


{-| Specify the font size and family to use when rendering text.

  - `size`: What is the size of the text in pixels. Similar to the `font-size`
    property in CSS.
  - `family`: Font family name to use when drawing the text. For example, you can
    use `"monospace"`, `"serif"` or `"sans-serif"` to use the user configured
    default fonts in the browser. You can also specify other font names like
    `"Consolas"`.

-}
font : { size : Int, family : String } -> Setting
font { size, family } =
    (String.fromInt size ++ "px " ++ family)
        |> I.font
        |> SettingCommand


{-| Specifies the text alignment to use when drawing text. Beware
that the alignment is based on the x value of position passed to `text`. So if
`textAlign` is `Center`, then the text would be drawn at `x - (width / 2)`.

The default value is `Start`. [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/textAlign)

-}
align : TextAlign -> Setting
align alignment =
    SettingCommand <| I.textAlign <| textAlignToString alignment


{-| Specifies the current text baseline being used when drawing text.

The default value is `Alphabetic`.

See [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/textBaseline)
for examples and rendering of the different modes.

-}
baseLine : TextBaseLine -> Setting
baseLine textBaseLine =
    SettingCommand <| I.textBaseline <| textBaseLineToString textBaseLine


{-| Specify a maximum width. The text is scaled to fit that width.
-}
maxWidth : Float -> Setting
maxWidth width =
    SettingUpdateDrawable
        (\d ->
            case d of
                DrawableText txt ->
                    DrawableText { txt | maxWidth = Just width }

                DrawableShapes _ ->
                    d

                DrawableTexture _ _ ->
                    d
        )



-- Textures


{-| Draw a texture into your canvas.

Textures can be loaded by using `toHtmlWith` and passing in a `Texture.Source`.
Once the texture is loaded, and you have an actual `Texture`, you can use it
with this method to draw it.

You can also make different types of textures from the same texture, in case you
have a big sprite sheet and want to create smaller textures that are
a _viewport_ into a bigger sheet.

See the `Canvas.Texture` module and the `sprite` function in it.

-}
texture : List Setting -> Point -> Texture -> Renderable
texture settings p t =
    addSettingsToRenderable settings
        (Renderable
            { commands = []
            , drawOp = NotSpecified
            , drawable = DrawableTexture p t
            }
        )



-- Advanced rendering settings
-- Line settings


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


lineCapToString cap =
    case cap of
        ButtCap ->
            "butt"

        RoundCap ->
            "round"

        SquareCap ->
            "square"


{-| Determines how two connecting segments with non-zero lengths in a shape are
joined together.

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

You can see examples and pictures on the [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/lineJoin)

-}
type LineJoin
    = BevelJoin
    | RoundJoin
    | MiterJoin


lineJoinToString join =
    case join of
        BevelJoin ->
            "bevel"

        RoundJoin ->
            "round"

        MiterJoin ->
            "miter"


{-| Determines how the end points of every line are drawn. See `LineCap` for the
possible types. By default `ButtCap` is used. See the [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/lineCap)
for examples.
-}
lineCap : LineCap -> Setting
lineCap cap =
    cap |> lineCapToString |> I.lineCap |> SettingCommand


{-| Specify the line dash pattern offset or "phase".

There are visual examples and more information in the [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/lineDashOffset)

-}
lineDashOffset : Float -> Setting
lineDashOffset offset =
    I.lineDashOffset offset
        |> SettingCommand


{-| Specify how two connecting segments (of lines, arcs or curves) with
non-zero lengths in a shape are joined together (degenerate segments with zero
lengths, whose specified endpoints and control points are exactly at the same
position, are skipped). See the type `LineJoin`.

By default this property is set to `MiterJoin`. Note that the `lineJoin` setting
has no effect if the two connected segments have the same direction, because no
joining area will be added in this case.

More information and examples in the [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/lineJoin)

-}
lineJoin : LineJoin -> Setting
lineJoin join =
    join |> lineJoinToString |> I.lineJoin |> SettingCommand


{-| Specify the thickness of lines in space units. When passing zero, negative,
Infinity and NaN values are ignored. More information and examples in the [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/lineWidth)
-}
lineWidth : Float -> Setting
lineWidth width =
    I.lineWidth width |> SettingCommand


{-| Specify the miter limit ratio in space units. When passing zero, negative,
Infinity and NaN values are ignored. It defaults to 10.

More information and live example in the [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/miterLimit)

-}
miterLimit : Float -> Setting
miterLimit limit =
    I.miterLimit limit |> SettingCommand


{-| Specify the line dash pattern used when stroking lines, using a list of
values which specify alternating lengths of lines and gaps which describe the
pattern.

    lineDash segments

  - `segments`
      - A list of numbers which specify distances to alternately draw a line
        and a gap (in coordinate space units). If the number of elements in the list
        is odd, the elements of the list get copied and concatenated. For example, `[5,
        15, 25]` will become `[5, 15, 25, 5, 15, 25]`. If the list is empty, the line
        dash list is clear and line strokes are solid.

You can see examples and more information in the [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/setLineDash)

-}
lineDash : List Float -> Setting
lineDash dashSettings =
    I.setLineDash dashSettings |> SettingCommand



-- Global style settings


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


globalCompositeOperationModeToString : GlobalCompositeOperationMode -> String
globalCompositeOperationModeToString mode =
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


{-| Record with the settings for a shadow.

  - `blur`: Amount of blur for the shadow
  - `color`: `Color` of the shadow (from avh4/elm-color)
  - `offset`: `( xOffset, yOffset )`

-}
type alias Shadow =
    { blur : Float, color : Color, offset : ( Float, Float ) }


{-| Specify a shadow to be rendered. See the `Shadow` type alias to know what
parameters to pass.
-}
shadow : Shadow -> Setting
shadow { blur, color, offset } =
    let
        ( x, y ) =
            offset
    in
    SettingCommands
        [ I.shadowBlur blur
        , I.shadowColor color
        , I.shadowOffsetX x
        , I.shadowOffsetY y
        ]


{-| Specifies the alpha value that is applied before renderables are drawn onto
the canvas. The value is in the range from 0.0 (fully transparent) to 1.0 (fully
opaque). The default value is 1.0. Values outside the range, including
`Infinity` and `NaN` will not be set and alpha will remain default.
-}
alpha : Float -> Setting
alpha a =
    I.globalAlpha a |> SettingCommand


{-| Specify the type of compositing operation to apply when drawing new
entities, where type is a `GlobalCompositeOperationMode` identifying which of
the compositing or blending mode operations to use.

See `GlobalCompositeOperationMode` below for more information.

    compositeOperationMode Screen

-}
compositeOperationMode : GlobalCompositeOperationMode -> Setting
compositeOperationMode mode =
    mode |> globalCompositeOperationModeToString |> I.globalCompositeOperation |> SettingCommand



-- Transforms


{-| Type of transform to apply to the matrix, to be used in `transform`. See the
functions below to learn how to create transforms.
-}
type Transform
    = Rotate Float
    | Scale Float Float
    | Translate Float Float
    | ApplyMatrix
        { m11 : Float
        , m12 : Float
        , m21 : Float
        , m22 : Float
        , dx : Float
        , dy : Float
        }


{-| Specify the transform matrix to apply when drawing. You do so by applying
transforms in order, like `translate`, `rotate`, or `scale`, but you can also
use `applyMatrix` and set the matrix yourself manually if you know what you are
doing.

    shapes
        [ transform [ rotate (degrees 50) ] ]
        [ rect ( 40, 40 ) 20 20 ]

-}
transform : List Transform -> Setting
transform transforms =
    SettingCommands <|
        List.map
            (\t ->
                case t of
                    Rotate angle ->
                        I.rotate angle

                    Scale x y ->
                        I.scale x y

                    Translate x y ->
                        I.translate x y

                    ApplyMatrix { m11, m12, m21, m22, dx, dy } ->
                        I.transform m11 m12 m21 m22 dx dy
            )
            transforms


{-| Adds a rotation to the transformation matrix. The `angle` argument
represents a clockwise rotation angle and is expressed in radians. Use the core
function `degrees` to make it easier to represent the rotation.

    rotate (degrees 90)

The rotation center point is always the canvas origin. To change the center
point, we will need to move the canvas by using the `translate` transform before
rotating. For example, a very common use case to rotate from a specific point in
the canvas, maybe the center of your renderable, would be done by translating to
that point, rotating, and then translating back, if you want to apply more
transformations. Like this:

    transform
        [ translate x y
        , rotate rotation
        , translate -x -y

        {- Other transforms -}
        ]

See the [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/rotate)
for more information and examples.

-}
rotate : Float -> Transform
rotate =
    Rotate


{-| Adds a scaling transformation to the canvas units by `x` horizontally and by
`y` vertically.

By default, one unit on the canvas is exactly one pixel. If we apply, for
instance, a scaling factor of 0.5, the resulting unit would become 0.5 pixels
and so shapes would be drawn at half size. In a similar way setting the scaling
factor to 2.0 would increase the unit size and one unit now becomes two pixels.
This results in shapes being drawn twice as large.

    scale x y

  - `x`
      - Scaling factor in the horizontal direction.
  - `y`
      - Scaling factor in the vertical direction.

**Note**: You can use `scale -1 1` to flip the context horizontally and `scale 1
-1` to flip it vertically.

More information and examples in the [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/scale)

-}
scale : Float -> Float -> Transform
scale =
    Scale


{-| Adds a translation transformation by moving the canvas and its origin `x`
units horizontally and `y` units vertically on the grid.

More information and examples on the [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/translate)

    translate x y

-}
translate : Float -> Float -> Transform
translate =
    Translate


{-| Multiplies the current transformation with the matrix described by the
arguments of this method. You are able to scale, rotate, move and skew the
context.

  - `m11`
      - Horizontal scaling.
  - `m12`
      - Horizontal skewing.
  - `m21`
      - Vertical skewing.
  - `m22`
      - Vertical scaling.
  - `dx`
      - Horizontal moving.
  - `dy`
      - Vertical moving.

-}
applyMatrix :
    { m11 : Float
    , m12 : Float
    , m21 : Float
    , m22 : Float
    , dx : Float
    , dy : Float
    }
    -> Transform
applyMatrix =
    ApplyMatrix



-- Rendering internals


render : List Renderable -> Commands
render entities =
    List.foldl renderOne I.empty entities


renderOne : Renderable -> Commands -> Commands
renderOne (Renderable ({ commands, drawable, drawOp } as data)) cmds =
    cmds
        |> (::) I.save
        |> (++) commands
        |> renderDrawable drawable drawOp
        |> (::) I.restore


renderDrawable : Drawable -> DrawOp -> Commands -> Commands
renderDrawable drawable drawOp cmds =
    case drawable of
        DrawableText txt ->
            renderText drawOp txt cmds

        DrawableShapes ss ->
            List.foldl renderShape (I.beginPath :: cmds) ss
                |> renderShapeDrawOp drawOp

        DrawableTexture p t ->
            renderTexture p t cmds


renderShape : Shape -> Commands -> Commands
renderShape shape cmds =
    case shape of
        Rect ( x, y ) w h ->
            I.rect x y w h :: I.moveTo x y :: cmds

        Circle ( x, y ) r ->
            I.circle x y r :: I.moveTo (x + r) y :: cmds

        Path ( x, y ) segments ->
            List.foldl renderLineSegment (I.moveTo x y :: cmds) segments

        Arc ( x, y ) radius startAngle endAngle anticlockwise ->
            I.arc x y radius startAngle endAngle anticlockwise
                :: I.moveTo (x + cos startAngle) (y + sin startAngle)
                :: cmds


renderLineSegment : PathSegment -> Commands -> Commands
renderLineSegment segment cmds =
    case segment of
        ArcTo ( x, y ) ( x2, y2 ) radius ->
            I.arcTo x y x2 y2 radius :: cmds

        BezierCurveTo ( cp1x, cp1y ) ( cp2x, cp2y ) ( x, y ) ->
            I.bezierCurveTo cp1x cp1y cp2x cp2y x y :: cmds

        LineTo ( x, y ) ->
            I.lineTo x y :: cmds

        MoveTo ( x, y ) ->
            I.moveTo x y :: cmds

        QuadraticCurveTo ( cpx, cpy ) ( x, y ) ->
            I.quadraticCurveTo cpx cpy x y :: cmds


renderText : DrawOp -> Text -> Commands -> Commands
renderText drawOp txt cmds =
    cmds
        |> renderTextDrawOp drawOp txt


renderTextDrawOp : DrawOp -> Text -> Commands -> Commands
renderTextDrawOp drawOp txt cmds =
    let
        ( x, y ) =
            txt.point
    in
    case drawOp of
        NotSpecified ->
            renderTextFill txt x y Color.black cmds

        Fill c ->
            renderTextFill txt x y c cmds

        Stroke c ->
            renderTextStroke txt x y c cmds

        FillAndStroke fc sc ->
            cmds
                |> renderTextFill txt x y fc
                |> renderTextStroke txt x y sc


renderTextFill txt x y color cmds =
    I.fillText txt.text x y txt.maxWidth
        :: I.fillStyle color
        :: cmds


renderTextStroke txt x y color cmds =
    I.strokeText txt.text x y txt.maxWidth
        :: I.strokeStyle color
        :: cmds


renderShapeDrawOp : DrawOp -> Commands -> Commands
renderShapeDrawOp drawOp cmds =
    case drawOp of
        NotSpecified ->
            renderShapeFill Color.black cmds

        Fill c ->
            renderShapeFill c cmds

        Stroke c ->
            renderShapeStroke c cmds

        FillAndStroke fc sc ->
            cmds
                |> renderShapeFill fc
                |> renderShapeStroke sc


renderShapeFill : Color -> Commands -> Commands
renderShapeFill c cmds =
    I.fill I.NonZero :: I.fillStyle c :: cmds


renderShapeStroke : Color -> Commands -> Commands
renderShapeStroke c cmds =
    I.stroke :: I.strokeStyle c :: cmds


renderTexture : Point -> Texture -> Commands -> Commands
renderTexture ( x, y ) t cmds =
    TI.drawTexture x y t cmds


renderTextureSource : Texture.Source msg -> ( String, Html msg )
renderTextureSource textureSource =
    case textureSource of
        TI.TSImageUrl url onLoad ->
            ( url
            , img
                [ src url
                , style "display" "none"
                , on "load" (D.map (TI.TImage >> Just >> onLoad) decodeTextureImageInfo)
                , on "error" (D.succeed (onLoad Nothing))
                ]
                []
            )


decodeTextureImageInfo : D.Decoder TI.Image
decodeTextureImageInfo =
    D.field "target" D.value
        |> D.andThen
            (\target ->
                D.map2
                    (\width height ->
                        { json = target
                        , width = width
                        , height = height
                        }
                    )
                    (D.at [ "target", "width" ] D.int)
                    (D.at [ "target", "height" ] D.int)
            )
