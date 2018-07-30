# joakin/elm-canvas

This library exposes a low level API that mirrors most of the DOM canvas API to
be used with Elm in a declarative way.

<p align="center">
  <a href="https://joakin.github.io/elm-canvas">Live examples</a>
</p>

<p align="center">
  <img width="200" src="https://joakin.github.io/elm-canvas/particles.png" />
  <img width="200" src="https://joakin.github.io/elm-canvas/animated-grid.png" />
  <img width="200" src="https://joakin.github.io/elm-canvas/dynamic-particles.png" />
  <img width="200" src="https://joakin.github.io/elm-canvas/circle-packing.png" />
  <img width="200" src="https://joakin.github.io/elm-canvas/trees.png" />
</p>

---

WARNING: This library is intended as a very low-level API that mirrors the DOM
API almost exactly, while providing a bit of extra type safety where it makes
sense. The DOM API is highly stateful and side-effectful, so be careful. To
understand how to use this library properly, please read the MDN docs:
<https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D> and
all the nested pages

## Usage

To use it, remember to include the `elm-canvas` custom element script in your
page before you initialize your Elm application.

- <http://unpkg.com/elm-canvas/elm-canvas.js>
- <http://npmjs.com/package/elm-canvas>

Then, you can add your HTML element like this:

```elm
module Main exposing (main)

import Canvas

view : Html Msg
view =
    let
        width = 500
        height = 300
    in
        Canvas.element
            width
            height
            [ style [ ( "border", "1px solid black" ) ] ]
            [ Canvas.clearRect 0 0 width height
            , renderSquare
            ]

renderSquare =
    batch
        [ Canvas.fillStyle (Color.rgba 0 0 0 1)
        , Canvas.fillRect 0 0 100 50
        ]

main = view
```

## Examples

You can see many examples in the
[examples/](https://github.com/joakin/elm-canvas/tree/master/examples) folder,
and experience them [live](https://joakin.github.io/elm-canvas).

```

```
