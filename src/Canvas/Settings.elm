module Canvas.Settings exposing
    ( Setting
    , fill, stroke
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
    on the `Canvas.Settings.Advanced`. They cover things like:
      - Shadows.
      - Matrix transforms.
      - And other more advanced topics like compositing mode.

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
