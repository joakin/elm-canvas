module Canvas exposing
    ( toHtml
    , Renderable, Point
    , fill, stroke
    , Shape, shapes, rect, circle, arc, arcC, arcTo, bezierCurveTo, lineTo, moveTo, quadraticCurveTo
    , Text, text, size, family, align, baseLine
    , lineDash, lineCap, lineDashOffset, lineJoin, lineWidth, miterLimit
    , Shadow, shadow, alpha, compositeOperationMode
    , Transform(..), transform, translate, rotate, scale, applyMatrix
    , GlobalCompositeOperationMode(..), LineCap(..), LineJoin(..), TextAlign(..), TextBaseLine(..)
    )

{-| This module exposes a nice drawing API that works on top of the the DOM
canvas.

See instructions in the main page of the package for installation, as it
requires a web component.


# Usage in HTML

@docs toHtml


# Drawing things to screen

@docs Renderable, Point
@docs fill, stroke


# Drawing shapes and lines

@docs Shape, shapes, rect, circle, arc, arcC, arcTo, bezierCurveTo, lineTo, moveTo, quadraticCurveTo


# Drawing text

@docs Text, text, TextAlign(..), TextBaseLine(..), size, family, align, baseLine


# Advanced rendering concepts

@docs lineDash, LineCap(..), lineCap, lineDashOffset, LineJoin(..), lineJoin, lineWidth, miterLimit

@docs Shadow, shadow, alpha, GlobalCompositeOperationMode(..), compositeOperationMode

@docs Transform, transform, translate, rotate, scale, applyMatrix

-}

import Canvas.Internal as I exposing (Commands, commands)
import Color exposing (Color)
import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Encode as Encode exposing (..)



-- HTML


{-| Create a Html element that you can use in your view.
-}
toHtml : ( Int, Int ) -> List (Attribute msg) -> List Renderable -> Html msg
toHtml ( w, h ) attrs entities =
    Html.node "elm-canvas"
        [ commands (render entities) ]
        [ canvas (height h :: width w :: attrs) []
        ]



-- Types


type alias Point =
    ( Float, Float )


type Renderable
    = Renderable
        { settings : Settings
        , drawOp : DrawOp
        , transforms : List Transform
        , drawable : Drawable
        }


type Drawable
    = DrawableText Text
    | DrawableShapes Shapes


type DrawOp
    = NotSpecified
    | Fill Color
    | Stroke Color
    | FillAndStroke Color Color


fill : Color -> Renderable -> Renderable
fill color (Renderable data) =
    Renderable
        { data
            | drawOp =
                case data.drawOp of
                    NotSpecified ->
                        Fill color

                    Fill _ ->
                        Fill color

                    Stroke strokeColor ->
                        FillAndStroke color strokeColor

                    FillAndStroke _ strokeColor ->
                        FillAndStroke color strokeColor
        }


stroke : Color -> Renderable -> Renderable
stroke color (Renderable data) =
    Renderable
        { data
            | drawOp =
                case data.drawOp of
                    NotSpecified ->
                        Stroke color

                    Fill fillColor ->
                        FillAndStroke fillColor color

                    Stroke strokeColor ->
                        Stroke color

                    FillAndStroke fillColor _ ->
                        FillAndStroke fillColor color
        }



-- Shapes drawables


type alias Shapes =
    List Shape


type Shape
    = Rect Point Float Float
    | Circle Point Float
    | Arc Point Float Float Float Bool
    | ArcTo Point Point Float
    | BezierCurveTo Point Point Point
    | LineTo Point
    | MoveTo Point
    | QuadraticCurveTo Point Point


shapes : List Shape -> Renderable
shapes ss =
    Renderable
        { settings = defaultSettings
        , drawOp = NotSpecified
        , transforms = []
        , drawable = DrawableShapes ss
        }


rect : Point -> Float -> Float -> Shape
rect pos width height =
    Rect pos width height


circle : Point -> Float -> Shape
circle pos radius =
    Circle pos radius


arc : Point -> Float -> Float -> Float -> Shape
arc pos radius startAngle endAngle =
    Arc pos radius startAngle endAngle False


arcC : Point -> Float -> Float -> Float -> Shape
arcC pos radius startAngle endAngle =
    Arc pos radius startAngle endAngle True


arcTo : Point -> Point -> Float -> Shape
arcTo pos1 pos2 radius =
    ArcTo pos1 pos2 radius


bezierCurveTo : Point -> Point -> Point -> Shape
bezierCurveTo controlPoint1 controlPoint2 point =
    BezierCurveTo controlPoint1 controlPoint2 point


lineTo : Point -> Shape
lineTo point =
    LineTo point


moveTo : Point -> Shape
moveTo point =
    MoveTo point


quadraticCurveTo : Point -> Point -> Shape
quadraticCurveTo controlPoint point =
    QuadraticCurveTo controlPoint point



-- Text drawables


type Text
    = Text { settings : TextSettings, point : Point, text : String }


text : Point -> String -> Renderable
text point str =
    Renderable
        { settings = defaultSettings
        , drawOp = NotSpecified
        , transforms = []
        , drawable = DrawableText (Text { settings = defaultTextSettings, point = point, text = str })
        }


type alias TextSettings =
    { size : Maybe Int
    , family : Maybe String
    , align : Maybe TextAlign
    , baseLine : Maybe TextBaseLine
    , maxWidth : Maybe Float
    }


defaultTextSettings =
    { size = Nothing
    , family = Nothing
    , align = Nothing
    , baseLine = Nothing
    , maxWidth = Nothing
    }


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


updateDrawableTextSetting : (TextSettings -> TextSettings) -> Renderable -> Renderable
updateDrawableTextSetting update ((Renderable ({ drawable } as data)) as entity) =
    case drawable of
        DrawableText (Text txt) ->
            Renderable { data | drawable = DrawableText (Text { txt | settings = update txt.settings }) }

        DrawableShapes _ ->
            entity


size : Int -> Renderable -> Renderable
size px entity =
    updateDrawableTextSetting (\s -> { s | size = Just px }) entity


family : String -> Renderable -> Renderable
family fontFamily entity =
    updateDrawableTextSetting (\s -> { s | family = Just fontFamily }) entity


align : TextAlign -> Renderable -> Renderable
align alignment entity =
    updateDrawableTextSetting (\s -> { s | align = Just alignment }) entity


baseLine : TextBaseLine -> Renderable -> Renderable
baseLine textBaseLine entity =
    updateDrawableTextSetting (\s -> { s | baseLine = Just textBaseLine }) entity


maxWidth : Float -> Renderable -> Renderable
maxWidth width entity =
    updateDrawableTextSetting (\s -> { s | maxWidth = Just width }) entity



-- Advanced rendering settings


type alias Settings =
    { lineSettings : LineSettings
    , shadow : Maybe Shadow
    , globalAlpha : Maybe Float
    , globalCompositeOperationMode : Maybe GlobalCompositeOperationMode
    }


defaultSettings : Settings
defaultSettings =
    { lineSettings = defaultLineSettings
    , shadow = Nothing
    , globalAlpha = Nothing
    , globalCompositeOperationMode = Nothing
    }



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


lineJoinToString join =
    case join of
        BevelJoin ->
            "bevel"

        RoundJoin ->
            "round"

        MiterJoin ->
            "miter"


type alias LineSettings =
    { lineCap : Maybe LineCap
    , lineDashOffset : Maybe Float
    , lineJoin : Maybe LineJoin
    , lineWidth : Maybe Float
    , miterLimit : Maybe Float
    , lineDash : Maybe (List Float)
    }


defaultLineSettings =
    { lineCap = Nothing
    , lineDashOffset = Nothing
    , lineJoin = Nothing
    , lineWidth = Nothing
    , miterLimit = Nothing
    , lineDash = Nothing
    }


updateLineSettings : (LineSettings -> LineSettings) -> Renderable -> Renderable
updateLineSettings update ((Renderable ({ settings } as data)) as entity) =
    Renderable { data | settings = { settings | lineSettings = update settings.lineSettings } }


lineCap : LineCap -> Renderable -> Renderable
lineCap cap entity =
    updateLineSettings (\s -> { s | lineCap = Just cap }) entity


lineDashOffset : Float -> Renderable -> Renderable
lineDashOffset offset entity =
    updateLineSettings (\s -> { s | lineDashOffset = Just offset }) entity


lineJoin : LineJoin -> Renderable -> Renderable
lineJoin join entity =
    updateLineSettings (\s -> { s | lineJoin = Just join }) entity


lineWidth : Float -> Renderable -> Renderable
lineWidth width entity =
    updateLineSettings (\s -> { s | lineWidth = Just width }) entity


miterLimit : Float -> Renderable -> Renderable
miterLimit limit entity =
    updateLineSettings (\s -> { s | miterLimit = Just limit }) entity


lineDash : List Float -> Renderable -> Renderable
lineDash dashSettings entity =
    updateLineSettings (\s -> { s | lineDash = Just dashSettings }) entity



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


type alias Shadow =
    { blur : Float, color : Color, offset : ( Float, Float ) }


updateSettings : (Settings -> Settings) -> Renderable -> Renderable
updateSettings update ((Renderable ({ settings } as data)) as entity) =
    Renderable { data | settings = update settings }


shadow : Shadow -> Renderable -> Renderable
shadow sh entity =
    updateSettings (\s -> { s | shadow = Just sh }) entity


alpha : Float -> Renderable -> Renderable
alpha a entity =
    updateSettings (\s -> { s | globalAlpha = Just a }) entity


compositeOperationMode : GlobalCompositeOperationMode -> Renderable -> Renderable
compositeOperationMode mode entity =
    updateSettings (\s -> { s | globalCompositeOperationMode = Just mode }) entity



-- Transforms


type Transform
    = Rotate Float
    | Scale Float Float
    | Translate Float Float
    | ApplyMatrix Float Float Float Float Float Float


transform : List Transform -> Renderable -> Renderable
transform newTransforms (Renderable ({ transforms } as data)) =
    Renderable
        { data
            | transforms =
                case transforms of
                    [] ->
                        newTransforms

                    _ ->
                        transforms ++ newTransforms
        }


rotate : Float -> Transform
rotate =
    Rotate


scale : Float -> Float -> Transform
scale =
    Scale


translate : Float -> Float -> Transform
translate =
    Translate


{-| Multiplies the current transformation with the matrix described by the
arguments of this method. You are able to scale, rotate, move and skew the
context.

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

-}
applyMatrix : Float -> Float -> Float -> Float -> Float -> Float -> Transform
applyMatrix =
    ApplyMatrix



-- Rendering internals


render : List Renderable -> Commands
render entities =
    List.foldl renderOne I.empty entities


renderOne : Renderable -> Commands -> Commands
renderOne (Renderable ({ settings, drawable, drawOp, transforms } as data)) cmds =
    cmds
        |> (::) I.save
        |> renderSettings settings
        |> renderTransforms transforms
        |> renderDrawable drawable drawOp
        |> (::) I.restore


maybeCons : Maybe a -> (a -> b) -> List b -> List b
maybeCons maybe mapper list =
    maybeConsMany maybe (\value -> mapper value :: list) list


maybeConsMany : Maybe a -> (a -> List b) -> List b -> List b
maybeConsMany maybe mapper list =
    maybe
        |> Maybe.map (\value -> mapper value)
        |> Maybe.withDefault list


renderSettings : Settings -> Commands -> Commands
renderSettings settings cmds =
    cmds
        |> maybeConsMany settings.shadow (\sh -> renderShadow sh cmds)
        |> maybeCons settings.globalAlpha I.globalAlpha
        |> maybeCons
            settings.globalCompositeOperationMode
            (I.globalCompositeOperation << globalCompositeOperationModeToString)
        |> renderLineSettings settings.lineSettings


renderShadow : Shadow -> Commands -> Commands
renderShadow { blur, color, offset } cmds =
    let
        ( x, y ) =
            offset
    in
    I.shadowBlur blur
        :: I.shadowColor color
        :: I.shadowOffsetX x
        :: I.shadowOffsetY y
        :: cmds


renderLineSettings : LineSettings -> Commands -> Commands
renderLineSettings s cmds =
    cmds
        |> maybeCons s.lineCap (I.lineCap << lineCapToString)
        |> maybeCons s.lineDashOffset I.lineDashOffset
        |> maybeCons s.lineJoin (I.lineJoin << lineJoinToString)
        |> maybeCons s.lineWidth I.lineWidth
        |> maybeCons s.miterLimit I.miterLimit
        |> maybeCons s.lineDash I.setLineDash


renderTransforms : List Transform -> Commands -> Commands
renderTransforms ts cmds =
    List.foldl
        (\t cs ->
            (case t of
                Rotate angle ->
                    I.rotate angle

                Scale x y ->
                    I.scale x y

                Translate x y ->
                    I.translate x y

                ApplyMatrix a b c d e f ->
                    I.transform a b c d e f
            )
                :: cs
        )
        cmds
        ts


renderDrawable : Drawable -> DrawOp -> Commands -> Commands
renderDrawable drawable drawOp cmds =
    case drawable of
        DrawableText txt ->
            renderText drawOp txt cmds

        DrawableShapes ss ->
            List.foldl renderShape (I.beginPath :: cmds) ss
                |> renderShapeDrawOp drawOp


renderShape : Shape -> Commands -> Commands
renderShape shape cmds =
    case shape of
        Rect ( x, y ) w h ->
            I.rect x y w h :: I.moveTo x y :: cmds

        Circle ( x, y ) r ->
            I.circle x y r :: I.moveTo (x + r) y :: cmds

        Arc ( x, y ) radius startAngle endAngle anticlockwise ->
            I.arc x y radius startAngle endAngle anticlockwise
                :: I.moveTo (x + cos startAngle) (y + sin startAngle)
                :: cmds

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
renderText drawOp ((Text t) as txt) cmds =
    cmds
        |> renderTextSettings t.settings
        |> renderTextDrawOp drawOp txt


renderTextSettings : TextSettings -> Commands -> Commands
renderTextSettings textSettings cmds =
    let
        format s f =
            String.fromInt s ++ "px " ++ f

        sizeAndFont =
            case ( textSettings.size, textSettings.family ) of
                ( Just s, Just f ) ->
                    Just (format s f)

                ( Just s, Nothing ) ->
                    Just (format s "sans-serif")

                ( Nothing, Just f ) ->
                    Just (format 20 f)

                ( Nothing, Nothing ) ->
                    Nothing
    in
    cmds
        |> maybeCons sizeAndFont I.font
        |> maybeCons textSettings.align (I.textAlign << textAlignToString)
        |> maybeCons textSettings.baseLine (I.textBaseline << textBaseLineToString)


renderTextDrawOp : DrawOp -> Text -> Commands -> Commands
renderTextDrawOp drawOp (Text txt) cmds =
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
    I.fillText txt.text x y txt.settings.maxWidth
        :: I.fillStyle color
        :: cmds


renderTextStroke txt x y color cmds =
    I.strokeText txt.text x y txt.settings.maxWidth
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
