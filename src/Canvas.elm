module Canvas exposing
    ( toHtml, toHtmlWith
    , Renderable, Point
    , shapes, text, texture
    , Shape
    , rect, circle, arc, path
    , PathSegment, arcTo, bezierCurveTo, lineTo, moveTo, quadraticCurveTo
    )

{-| This module exposes a nice drawing API that works on top of the the DOM
canvas.

See instructions in the main page of the package for installation, as it
requires the `elm-canvas` web component to work.


# Usage in HTML

@docs toHtml, toHtmlWith


# Drawing things

@docs Renderable, Point

@docs shapes, text, texture


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

-}

import Canvas.Internal.Canvas as C exposing (..)
import Canvas.Internal.CustomElementJsonApi as CE exposing (Commands, commands)
import Canvas.Internal.Texture as T
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
        { commands : Commands
        , drawOp : DrawOp
        , drawable : Drawable
        }


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
type alias Shape =
    C.Shape


{-| In order to draw a path, you need to give the function `path` a list of
`PathSegment`
-}
type alias PathSegment =
    C.PathSegment


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



-- Rendering internals


render : List Renderable -> Commands
render entities =
    List.foldl renderOne CE.empty entities


renderOne : Renderable -> Commands -> Commands
renderOne (Renderable ({ commands, drawable, drawOp } as data)) cmds =
    cmds
        |> (::) CE.save
        |> (++) commands
        |> renderDrawable drawable drawOp
        |> (::) CE.restore


renderDrawable : Drawable -> DrawOp -> Commands -> Commands
renderDrawable drawable drawOp cmds =
    case drawable of
        DrawableText txt ->
            renderText drawOp txt cmds

        DrawableShapes ss ->
            List.foldl renderShape (CE.beginPath :: cmds) ss
                |> renderShapeDrawOp drawOp

        DrawableTexture p t ->
            renderTexture p t cmds


renderShape : Shape -> Commands -> Commands
renderShape shape cmds =
    case shape of
        Rect ( x, y ) w h ->
            CE.rect x y w h :: CE.moveTo x y :: cmds

        Circle ( x, y ) r ->
            CE.circle x y r :: CE.moveTo (x + r) y :: cmds

        Path ( x, y ) segments ->
            List.foldl renderLineSegment (CE.moveTo x y :: cmds) segments

        Arc ( x, y ) radius startAngle endAngle anticlockwise ->
            CE.arc x y radius startAngle endAngle anticlockwise
                :: CE.moveTo (x + cos startAngle) (y + sin startAngle)
                :: cmds


renderLineSegment : PathSegment -> Commands -> Commands
renderLineSegment segment cmds =
    case segment of
        ArcTo ( x, y ) ( x2, y2 ) radius ->
            CE.arcTo x y x2 y2 radius :: cmds

        BezierCurveTo ( cp1x, cp1y ) ( cp2x, cp2y ) ( x, y ) ->
            CE.bezierCurveTo cp1x cp1y cp2x cp2y x y :: cmds

        LineTo ( x, y ) ->
            CE.lineTo x y :: cmds

        MoveTo ( x, y ) ->
            CE.moveTo x y :: cmds

        QuadraticCurveTo ( cpx, cpy ) ( x, y ) ->
            CE.quadraticCurveTo cpx cpy x y :: cmds


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
    CE.fillText txt.text x y txt.maxWidth
        :: CE.fillStyle color
        :: cmds


renderTextStroke txt x y color cmds =
    CE.strokeText txt.text x y txt.maxWidth
        :: CE.strokeStyle color
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
    CE.fill CE.NonZero :: CE.fillStyle c :: cmds


renderShapeStroke : Color -> Commands -> Commands
renderShapeStroke c cmds =
    CE.stroke :: CE.strokeStyle c :: cmds


renderTexture : Point -> Texture -> Commands -> Commands
renderTexture ( x, y ) t cmds =
    T.drawTexture x y t cmds


renderTextureSource : Texture.Source msg -> ( String, Html msg )
renderTextureSource textureSource =
    case textureSource of
        T.TSImageUrl url onLoad ->
            ( url
            , img
                [ src url
                , style "display" "none"
                , on "load" (D.map (T.TImage >> Just >> onLoad) decodeTextureImageInfo)
                , on "error" (D.succeed (onLoad Nothing))
                ]
                []
            )


decodeTextureImageInfo : D.Decoder T.Image
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
