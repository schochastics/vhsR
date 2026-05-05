# Record a GIF demo from a script file

Reads `path` as R source, validates it parses, and records each line
typed into the recorded REPL. Equivalent to inlining the file contents
in
[`record_demo()`](https://schochastics.github.io/vhsR/reference/record_demo.md)
but accepts a path instead of an expression.

## Usage

``` r
record_demo_file(
  path,
  output = "demo.gif",
  ...,
  backend = c("auto", "arf", "radian", "R"),
  quiet = FALSE
)
```

## Arguments

- path:

  Path to an R script file.

- output:

  Path to the output file. The extension determines the format (`.gif`,
  `.mp4`, `.webm`).

- ...:

  Pacing and styling arguments forwarded to
  [`tape_options()`](https://schochastics.github.io/vhsR/reference/tape_options.md).
  Pass any of `width`, `height`, `font_size`, `theme`, `typing_speed`,
  `playback_speed`, `line_pause`, `start_pause`, `end_pause`,
  `paragraph_pause`, `typing_speed_jitter` by name. Unknown names error.

- backend:

  Which interactive R front-end to record. `"auto"` (the default)
  prefers `"arf"` (a Rust-based modern R console with tree-sitter syntax
  highlighting and zero runtime dependencies — see
  <https://github.com/eitsupi/arf>), falls back to `"radian"` if found,
  otherwise plain `"R"`.

- quiet:

  If `TRUE`, suppress vhs stdout/stderr.

## Value

Invisibly returns `output`.

## Examples

``` r
if (FALSE) { # \dontrun{
record_demo_file("script.R", output = "demo.gif")
} # }
```
