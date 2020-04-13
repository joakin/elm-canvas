module Canvas.Internal.Texture exposing
    ( Image
    , Source(..)
    , Sprite
    , Texture(..)
    , decodeImageLoadEvent
    , decodeTextureImage
    , drawTexture
    )

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


decodeImageLoadEvent : D.Decoder (Maybe Texture)
decodeImageLoadEvent =
    D.field "target" decodeTextureImage


decodeTextureImage : D.Decoder (Maybe Texture)
decodeTextureImage =
    -- TODO: Verify the Value is actually a DOM image
    D.value
        |> D.andThen
            (\image ->
                D.map3
                    (\tagName width height ->
                        if tagName == "IMG" then
                            Just
                                (TImage
                                    { json = image
                                    , width = width
                                    , height = height
                                    }
                                )

                        else
                            Nothing
                    )
                    (D.field "tagName" D.string)
                    (D.field "width" D.float)
                    (D.field "height" D.float)
            )


drawTexture : Float -> Float -> Texture -> Commands -> Commands
drawTexture x y t cmds =
    (case t of
        TImage image ->
            C.drawImage 0 0 image.width image.height x y image.width image.height image.json

        TSprite sprite image ->
            C.drawImage sprite.x sprite.y sprite.width sprite.height x y sprite.width sprite.height image.json
    )
        :: cmds
