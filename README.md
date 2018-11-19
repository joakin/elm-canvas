# joakin/elm-canvas

This library exposes a low level API that mirrors most of the DOM canvas API to
be used with Elm in a declarative way.

[Live examples](https://joakin.github.io/elm-canvas)
([sources](https://github.com/joakin/elm-canvas/tree/master/examples))

![](https://joakin.github.io/elm-canvas/animated-grid.png)
![](https://joakin.github.io/elm-canvas/dynamic-particles.png)
![](https://joakin.github.io/elm-canvas/circle-packing.png)
![](https://joakin.github.io/elm-canvas/trees.png)

---

**WARNING**: This library is in development and right now it only exposes a
low-level API that mirrors the DOM API, providing a bit of extra type safety
where it makes sense. The DOM API is highly stateful and side-effectful, so be
careful. To understand how to use this library for now, please familiarize
yourself with the
[MDN Canvas Tutorial](https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API/Tutorial).
We will be iterating on the design of the library to make it nicer and provide
better defaults as time goes by, and make specific tutorials with Elm.

## Usage

To use it, remember to include the `elm-canvas` custom element script in your
page before you initialize your Elm application.

- [Ellie basic example](https://ellie-app.com/38zhvnLGCKMa1)
  - Good starting point to play with the library.
- <http://unpkg.com/elm-canvas/elm-canvas.js>
  - CDN link. Visit it and copy the redirected URL with the version number into
    your HTML.
- <http://npmjs.com/package/elm-canvas>
  - See npm docs for version compatibility, in general, latest npm package
    should work fine with the latest elm package.

Then, you can add your HTML element like this:

```elm
module Main exposing (main)

import Canvas
import CanvasColor as Color
import Html exposing (Html)
import Html.Attributes exposing (style)

view : Html msg
view =
    let
        width = 500
        height = 300
    in
        Canvas.element
            width
            height
            [ style "border" "1px solid black" ]
            ( Canvas.empty
                |> Canvas.clearRect 0 0 width height
                |> renderSquare
            )

renderSquare cmds =
    cmds
        |> Canvas.fillStyle (Color.rgba 0 0 0 1)
        |> Canvas.fillRect 0 0 100 50

main = view
```

## Examples

You can see many examples in the
[examples/](https://github.com/joakin/elm-canvas/tree/master/examples) folder,
and experience them [live](https://joakin.github.io/elm-canvas).

```

```
