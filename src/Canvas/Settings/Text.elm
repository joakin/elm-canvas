module Canvas.Settings.Text exposing (font, align, TextAlign(..), baseLine, TextBaseLine(..), maxWidth)

{-|


# Styling text

To draw text we use the function `text`:

    text
        [ font { size = 48, family = "serif" }
        , align Center
        ]
        ( 50, 50 )
        "Hello world"

You can apply the following styling settings to text specifically. They will do
nothing if you apply them to other renderables, like `shapes`.

@docs font, align, TextAlign, baseLine, TextBaseLine, maxWidth

-}

import Canvas.Internal.Canvas exposing (..)
import Canvas.Internal.CustomElementJsonApi as CE exposing (..)
import Canvas.Settings exposing (Setting)


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


textBaseLineToString : TextBaseLine -> String
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
        |> CE.font
        |> SettingCommand


{-| Specifies the text alignment to use when drawing text. Beware
that the alignment is based on the x value of position passed to `text`. So if
`textAlign` is `Center`, then the text would be drawn at `x - (width / 2)`.

The default value is `Start`. [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/textAlign)

-}
align : TextAlign -> Setting
align alignment =
    SettingCommand <| CE.textAlign <| textAlignToString alignment


{-| Specifies the current text baseline being used when drawing text.

The default value is `Alphabetic`.

See [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/textBaseline)
for examples and rendering of the different modes.

-}
baseLine : TextBaseLine -> Setting
baseLine textBaseLine =
    SettingCommand <| CE.textBaseline <| textBaseLineToString textBaseLine


{-| Specify a maximum width. The text is scaled to fit that width.

Note: max-width must be directly applied to the text renderable, if applied to
a group it will have no effect.

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

                DrawableClear _ _ _ ->
                    d

                DrawableGroup _ ->
                    d
        )
