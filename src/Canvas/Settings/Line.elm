module Canvas.Settings.Line exposing (lineWidth, lineCap, LineCap(..), lineJoin, LineJoin(..), lineDash, lineDashOffset, miterLimit)

{-|


# Styling lines

Line style settings apply to paths, and the stroke of shapes and text.

@docs lineWidth, lineCap, LineCap, lineJoin, LineJoin, lineDash, lineDashOffset, miterLimit

-}

import Canvas.Internal.Canvas as C exposing (..)
import Canvas.Internal.CustomElementJsonApi as CE exposing (..)
import Canvas.Settings exposing (Setting)



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
    cap |> lineCapToString |> CE.lineCap |> SettingCommand


{-| Specify the line dash pattern offset or "phase".

There are visual examples and more information in the [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/lineDashOffset)

-}
lineDashOffset : Float -> Setting
lineDashOffset offset =
    CE.lineDashOffset offset
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
    join |> lineJoinToString |> CE.lineJoin |> SettingCommand


{-| Specify the thickness of lines in space units. When passing zero, negative,
Infinity and NaN values are ignored. More information and examples in the [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/lineWidth)
-}
lineWidth : Float -> Setting
lineWidth width =
    CE.lineWidth width |> SettingCommand


{-| Specify the miter limit ratio in space units. When passing zero, negative,
Infinity and NaN values are ignored. It defaults to 10.

More information and live example in the [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/miterLimit)

-}
miterLimit : Float -> Setting
miterLimit limit =
    CE.miterLimit limit |> SettingCommand


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
    CE.setLineDash dashSettings |> SettingCommand
