module Canvas.InternalTexture exposing (Image, Source(..), Sprite, Texture(..), drawTexture)

import Canvas.Internal as I exposing (Commands)
import Json.Decode as D


type alias Image =
    { json : D.Value
    , width : Int
    , height : Int
    }


type Source msg
    = TSImageUrl String (Maybe Texture -> msg)


type Texture
    = TImage Image
    | TSprite Sprite Image


type alias Sprite =
    { x : Int, y : Int, width : Int, height : Int }


drawTexture : Float -> Float -> Texture -> Commands -> Commands
drawTexture x y t cmds =
    (case t of
        TImage image ->
            I.drawImage (toFloat 0) (toFloat 0) (toFloat image.width) (toFloat image.height) x y (toFloat image.width) (toFloat image.height) image.json

        TSprite sprite image ->
            I.drawImage (toFloat sprite.x) (toFloat sprite.y) (toFloat sprite.width) (toFloat sprite.height) x y (toFloat sprite.width) (toFloat sprite.height) image.json
    )
        :: cmds
