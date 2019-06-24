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

import Canvas.Internal.Texture as T


{-| Origin of a texture to load. Passing a `List Source` to `Canvas.toHtmlWith`
will try to load the textures and send you events with the actual `Texture` when
it is loaded.
-}
type alias Source msg =
    T.Source msg


{-| The `Texture` type. You can use this type with `Canvas.texture` to get
a `Renderable` into the screen.
-}
type alias Texture =
    T.Texture


{-| Make a sprite from a texture. A sprite is like a window into a bigger
texture. By passing the inner coordinates and width and height of the window,
you will get a new texture back that is only that selected viewport into the
bigger texture.

Very useful for using sprite sheet textures.

-}
sprite : { x : Int, y : Int, width : Int, height : Int } -> Texture -> Texture
sprite data texture =
    case texture of
        T.TImage image ->
            T.TSprite data image

        T.TSprite _ image ->
            T.TSprite data image


{-| Make a `Texture.Source` from an image URL. When passing this Source to
`toHtmlWith` the image will try to be loaded and stored as a `Texture` ready to be drawn.
-}
loadFromImageUrl : String -> (Maybe Texture -> msg) -> Source msg
loadFromImageUrl url onLoad =
    T.TSImageUrl url onLoad


{-| Get the width and height of a texture
-}
dimensions : Texture -> { width : Int, height : Int }
dimensions texture =
    case texture of
        T.TImage image ->
            { width = image.width, height = image.height }

        T.TSprite data _ ->
            { width = data.width, height = data.height }
