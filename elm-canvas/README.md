# elm-canvas

Custom element to be used in conjunction with the
[joakin/elm-canvas](http://package.elm-lang.org/packages/joakin/elm-canvas/latest)
library.

This package exposes a file `elm-canvas.js` that you will need to include before
your elm application for it to work.

The file is ES2015 syntax and uses the `customElements` registry, so if you need
to support older browsers ensure you transpile this file to ES5 and add the
necessary polyfills (see
[this](https://gist.github.com/akoppela/8a19d9b039e9af21c4b27b5c4c998782) for
example).

You can also use this file from some CDN directly if you need to use it in ellie
or so like this:

- https://unpkg.com/elm-canvas/elm-canvas.js

Version compatibility:

| elm-canvas (Elm) | elm-canvas (npm) |
| ---------------- | ---------------- |
| 1.x              | 1.x              |
| 2.x              | 2.x              |
| 3.x              | 2.x              |
| >= 3.0.4         | 2.2.0            |
