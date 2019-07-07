module Canvas.Internal.Texture exposing (Image, Source(..), Sprite, Texture(..), drawTexture)

import Canvas.Internal.CustomElementJsonApi as C exposing (Commands)
import Json.Decode as D


type alias Image =
    { json : D.Value
    , width : Float
    , height : Float
    }


type Source msg
    = TSImageUrl String (Maybe Texture -> msg)


type Texture
    = TImage Image
    | TSprite Sprite Image


type alias Sprite =
    { x : Float, y : Float, width : Float, height : Float }


drawTexture : Float -> Float -> Texture -> Commands -> Commands
drawTexture x y t cmds =
    (case t of
        TImage image ->
            C.drawImage 0 0 image.width image.height x y image.width image.height image.json

        TSprite sprite image ->
            C.drawImage sprite.x sprite.y sprite.width sprite.height x y sprite.width sprite.height image.json
    )
        :: cmds
