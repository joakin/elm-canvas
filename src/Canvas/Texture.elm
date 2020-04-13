module Canvas.Texture exposing
    ( Source, loadFromImageUrl
    , fromDomImage
    , Texture
    , sprite
    , dimensions
    )

{-| This module exposes the types and functions to load and work with textures.

You can load textures by using `toHtmlWith`, and use them to draw with
`Canvas.texture`.


# Loading Textures


## From an external source

@docs Source, loadFromImageUrl


## From existing sources

@docs fromDomImage


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
import Json.Decode as D


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
sprite : { x : Float, y : Float, width : Float, height : Float } -> Texture -> Texture
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
dimensions : Texture -> { width : Float, height : Float }
dimensions texture =
    case texture of
        T.TImage image ->
            { width = image.width, height = image.height }

        T.TSprite data _ ->
            { width = data.width, height = data.height }


{-| Make a `Texture` from a DOM image.

For example, if you want to make textures out of images you loaded yourself in
JS and passed to Elm via ports or flags, you would use this method.

It will make a `Texture` validating that the `Json.Decode.Value` is an image
that can be drawn. If it isn't, you will get a `Nothing` back.

-}
fromDomImage : D.Value -> Maybe Texture
fromDomImage value =
    D.decodeValue T.decodeTextureImage value
        |> Result.toMaybe
        |> Maybe.andThen identity
