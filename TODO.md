# Possible improvements

* Make Task based HTTP texture fetching
* Make transforms based on the shape and size instead of the global canvas
* Provide full screen Canvas.sketch program
  * With auto resize and total time and frame diffs and viewport dimensions
* Make default toHTML clear the screen and custom have the option to not clear it
* Add shape batching / groups
* Performance benchmarking / improvements
  * Rendering vía hacky interop rather than json encoding?
  * object updates vs full object copy
* Document the coordinate system used
  * Should the coordinate system be different?
* Get rid of the tuple Point and make an object one with x and y fields
* Get rid of the tuple width height in favor of a named record
* Add elm-verify-examples
