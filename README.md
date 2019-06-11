# joakin/elm-canvas

This module exposes a nice drawing API that works on top of the the DOM canvas.

[Live examples](https://joakin.github.io/elm-canvas)
([example sources](https://github.com/joakin/elm-canvas/tree/master/examples))

![](https://joakin.github.io/elm-canvas/animated-grid.png)
![](https://joakin.github.io/elm-canvas/dynamic-particles.png)
![](https://joakin.github.io/elm-canvas/circle-packing.png)
![](https://joakin.github.io/elm-canvas/trees.png)

## Usage

To use it, read the docs on the `Canvas` module, and remember to include the
`elm-canvas` custom element script in your page before you initialize your Elm
application.

- [Ellie basic example](https://ellie-app.com/4Qf8fd4vWbva1)
  - Good starting point to play with the library without installing anything.
- Basic project template to get started:
  [joakin/elm-canvas-sketch](https://github.com/joakin/elm-canvas-sketch)
- <http://unpkg.com/elm-canvas/elm-canvas.js>
  - CDN link. Visit it and copy the redirected URL with the version number into
    your HTML.
- <http://npmjs.com/package/elm-canvas>
  - If you use a bundler like parcel or webpack, you can use the npm package
- See npm docs for version compatibility, in general, latest npm package/CDN
  link should work fine with the latest elm package.

Then, you can add your HTML element like this:

```elm
module Main exposing (main)

import Canvas exposing (..)
import Color
import Html exposing (Html)
import Html.Attributes exposing (style)

view : Html msg
view =
    let
        width = 500
        height = 300
    in
        Canvas.toHtml (width, height)
            [ style "border" "1px solid black" ]
            [ shapes [ fill Color.white ] [ rect (0, 0) width height ]
            , renderSquare
            ]

renderSquare =
  shapes [ fill (Color.rgba 0 0 0 1) ]
      [ rect (0, 0) 100 50 ]

main = view
```

## Examples

You can see many examples in the
[examples/](https://github.com/joakin/elm-canvas/tree/master/examples) folder,
and experience them [live](https://joakin.github.io/elm-canvas).

Additinally, some of the [p5js.org examples](https://p5js.org/examples/) where adopted to Elm using this package. They can be found [here](https://discourse.elm-lang.org/t/some-p5js-org-examples-in-elm/3781).

```

```
