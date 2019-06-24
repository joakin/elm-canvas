module Canvas.Texture exposing
    ( Source, loadFromImageUrl
    , Texture
    , sprite
    , dimensions
    )

{-| This module exposes the types and functions to load and work with textures.

You can use textures by using `toHtmlWith`.


# Loading Textures

@docs Source, loadFromImageUrl


# Texture types

@docs Texture

Once you have a texture, you can get a new texture with a viewport into an
existing one. This is very useful for when you have a sprite sheet with many
images in one, but want to have individual sprites to draw.

@docs sprite


# Texture information

You can get some information from the texture, like its dimensions:

@docs dimensions

-}

import Canvas.InternalTexture as I


type Image
    = Image I.Image


{-| Origin of a texture to load. Passing a `List Source` to `Canvas.toHtmlWith`
will try to load the textures and send you events with the actual `Texture` when
it is loaded.
-}
type alias Source msg =
    I.Source msg


{-| The `Texture` type. You can use this type with `Canvas.texture` to get
a `Renderable` into the screen.
-}
type alias Texture =
    I.Texture


{-| Make a sprite from a texture. A sprite is like a window into a bigger
texture. By passing the inner coordinates and width and height of the window,
you will get a new texture back that is only that selected viewport into the
bigger texture.

Very useful for using sprite sheet textures.

-}
sprite : { x : Int, y : Int, width : Int, height : Int } -> Texture -> Texture
sprite data texture =
    case texture of
        I.TImage image ->
            I.TSprite data image

        I.TSprite _ image ->
            I.TSprite data image


{-| Make a `Texture.Source` from an image URL. When passing this Source to
`toHtmlWith` the image will try to be loaded and stored as a `Texture` ready to be drawn.
-}
loadFromImageUrl : String -> (Maybe Texture -> msg) -> Source msg
loadFromImageUrl url onLoad =
    I.TSImageUrl url onLoad


{-| Get the width and height of a texture
-}
dimensions : Texture -> { width : Int, height : Int }
dimensions texture =
    case texture of
        I.TImage image ->
            { width = image.width, height = image.height }

        I.TSprite data _ ->
            { width = data.width, height = data.height }
