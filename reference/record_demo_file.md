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
  width = 1200,
  height = 600,
  font_size = 22,
  theme = "Catppuccin Mocha",
  typing_speed = "60ms",
  playback_speed = 1,
  line_pause = "500ms",
  backend = c("auto", "arf", "radian", "R"),
  start_pause = "800ms",
  end_pause = "500ms",
  paragraph_pause = NULL,
  typing_speed_jitter = 0,
  quiet = FALSE
)
```

## Arguments

- path:

  Path to an R script file.

- output:

  Path to the output file. The extension determines the format (`.gif`,
  `.mp4`, `.webm`).

- width, height:

  Terminal dimensions in pixels.

- font_size:

  Font size in pixels.

- theme:

  A vhs theme name (see vhs docs for the full list).

- typing_speed:

  Per-keystroke delay, e.g. `"60ms"`.

- playback_speed:

  Playback rate multiplier (1 = real time).

- line_pause:

  Delay after each line of R code, e.g. `"500ms"`.

- backend:

  Which interactive R front-end to record. `"auto"` (the default)
  prefers `"arf"` (a Rust-based modern R console with tree-sitter syntax
  highlighting and zero runtime dependencies — see
  <https://github.com/eitsupi/arf>), falls back to `"radian"` if found,
  otherwise plain `"R"`.

- start_pause:

  Delay between R startup and the first typed line (e.g. `"800ms"`).

- end_pause:

  Delay between the last typed line and the (hidden)
  [`q()`](https://rdrr.io/r/base/quit.html) exit (e.g. `"500ms"`).

- paragraph_pause:

  If set, blank lines in `expr` produce a sleep of this duration instead
  of being typed.

- typing_speed_jitter:

  Numeric in `[0, 1]`; when positive, each typed line uses a speed
  sampled uniformly within `±jitter` of `typing_speed`. Set
  [`base::set.seed()`](https://rdrr.io/r/base/Random.html) before
  calling for reproducible jitter.

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
