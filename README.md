# joakin/elm-canvas

This library exposes a low level API that mirrors most of the DOM canvas API to
be used with Elm in a declarative way.

[Live examples](https://joakin.github.io/elm-canvas)

To use it, remember to include the `elm-canvas` custom element script in your
page before you initialize your Elm application.

- <http://unpkg.com/elm-canvas/elm-canvas.js>
- <http://npmjs.com/package/elm-canvas>

WARNING: This library is intended as a very low-level API that mirrors the DOM
API almost exactly, while providing a bit of extra type safety where it makes
sense. The DOM API is highly stateful and side-effectful, so be careful. To
understand how to use this library properly, please read the MDN docs:
<https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D> and
all the nested pages

## Examples

You can see many examples in the
[examples/](https://github.com/joakin/elm-canvas/tree/master/examples) folder,
and experience them [live](https://joakin.github.io/elm-canvas).
