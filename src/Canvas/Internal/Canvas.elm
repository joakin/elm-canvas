module Canvas.Internal.Canvas exposing (DrawOp(..), Drawable(..), PathSegment(..), Point, Setting(..), Shape(..), Text)

import Canvas.Internal.CustomElementJsonApi as C exposing (Commands, commands)
import Canvas.Texture as Texture exposing (Texture)
import Color exposing (Color)


type alias Point =
    ( Float, Float )


type Setting
    = SettingCommand C.Command
    | SettingCommands C.Commands
    | SettingDrawOp DrawOp
    | SettingUpdateDrawable (Drawable -> Drawable)


type DrawOp
    = NotSpecified
    | Fill Color
    | Stroke Color
    | FillAndStroke Color Color


type Drawable
    = DrawableText Text
    | DrawableShapes (List Shape)
    | DrawableTexture Point Texture
    | DrawableClear Point Float Float


type alias Text =
    { maxWidth : Maybe Float, point : Point, text : String }


type Shape
    = Rect Point Float Float
    | Circle Point Float
    | Path Point (List PathSegment)
    | Arc Point Float Float Float Bool


type PathSegment
    = ArcTo Point Point Float
    | BezierCurveTo Point Point Point
    | LineTo Point
    | MoveTo Point
    | QuadraticCurveTo Point Point
