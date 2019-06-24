module Canvas.Settings exposing
    ( Setting
    , fill, stroke
    , shadow, Shadow
    , transform, Transform(..), translate, rotate, scale, applyMatrix
    , alpha, compositeOperationMode, GlobalCompositeOperationMode(..)
    )

{-|

@docs Setting


# Styling the things you draw

The two main style settings are fill color and stroke color, which are
documented here.

@docs fill, stroke


## Other frequently used settings

There are other style settings in the documentation (if you search for things
that return a `Setting` you can see). More specifically:

  - There are some style settings that only apply when drawing text, and you can
    find them in the `Canvas.Settings.Text` module.
  - Line settings that apply to paths, shapes and text with stroke. Learn about
    them on the `Canvas.Settings.Line`.
  - There are other more advanced rendering settings that you can read about
    further down in the **Advanced rendering settings** section. They cover
    things like:
      - Shadows.
      - Matrix transforms.
      - And other more advanced topics like compositing mode.


# Advanced rendering settings

The following are settings that you can apply, to create very specific and
custom effects.


## Shadows

The shadow setting allows you to create a shadow for a renderable, similar to
what the `box-shadow` CSS does to HTML elements.

A word of caution, shadows have a non-trivial performance cost, so use them
wisely.

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

import Canvas.Internal.Canvas as C exposing (..)
import Canvas.Internal.CustomElementJsonApi as CE exposing (..)
import Color exposing (Color)


{-| Similar to `Html.Attribute`, settings control the presentation and other
style options for the `Renderable`s.
-}
type alias Setting =
    C.Setting


{-| By default, renderables are drawn with black color. If you want to specify
a different color to draw, use this `Setting` on your renderable.

The type `Color` comes from the package `avh4/elm-color`. To use it explicitly,
run:

    -- elm install avh4/elm-color



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


{-| By default, renderables are drawn with no visible stroke. If you want to
specify a stroke color to draw an outline over your renderable, use this
`Setting` on it.

The type `Color` comes from the package `avh4/elm-color`. To use it explicitly,
run:

    -- elm install avh4/elm-color



and then import it in.

    import Color
    -- ...
    shapes
        [ stroke Color.red ]
        [ rect ( 10, 30 ) 50 50 ]

If you want to modify the appearance of the stroke line, you can use other
`Setting`s from the `Canvas.Settings.Line` module.

-}
stroke : Color -> Setting
stroke color =
    SettingDrawOp
        (Stroke color)



-- Advanced rendering settings
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
        [ CE.shadowBlur blur
        , CE.shadowColor color
        , CE.shadowOffsetX x
        , CE.shadowOffsetY y
        ]


{-| Specifies the alpha value that is applied before renderables are drawn onto
the canvas. The value is in the range from 0.0 (fully transparent) to 1.0 (fully
opaque). The default value is 1.0. Values outside the range, including
`Infinity` and `NaN` will not be set and alpha will remain default.
-}
alpha : Float -> Setting
alpha a =
    CE.globalAlpha a |> SettingCommand


{-| Specify the type of compositing operation to apply when drawing new
entities, where type is a `GlobalCompositeOperationMode` identifying which of
the compositing or blending mode operations to use.

See `GlobalCompositeOperationMode` below for more information.

    compositeOperationMode Screen

-}
compositeOperationMode : GlobalCompositeOperationMode -> Setting
compositeOperationMode mode =
    mode |> globalCompositeOperationModeToString |> CE.globalCompositeOperation |> SettingCommand



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
                        CE.rotate angle

                    Scale x y ->
                        CE.scale x y

                    Translate x y ->
                        CE.translate x y

                    ApplyMatrix { m11, m12, m21, m22, dx, dy } ->
                        CE.transform m11 m12 m21 m22 dx dy
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
