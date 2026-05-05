# Record a GIF demo of an R expression

Captures the unevaluated R expression `expr`, types it line-by-line into
a freshly-spawned R session inside a `vhs` recording, and writes the
result to `output`. The R front-end is chosen by `backend` (see below).
Setup is a one-liner: if the required binaries are missing, the function
points to
[`vhsr_install()`](https://schochastics.github.io/vhsR/reference/vhsr_install.md).

## Usage

``` r
record_demo(
  expr,
  output = "demo.gif",
  ...,
  backend = c("auto", "arf", "radian", "R"),
  tape = NULL,
  quiet = FALSE
)
```

## Arguments

- expr:

  An R expression (typically a `{ ... }` block). Captured unevaluated;
  lines are typed verbatim into the REPL.

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

- tape:

  Optional. A raw `.tape` script as a string (or path to a `.tape`
  file). When supplied, `expr` and the styling args are ignored and the
  tape is run verbatim.

- quiet:

  If `TRUE`, suppress vhs stdout/stderr.

## Value

Invisibly returns the path to the output file.

## See also

[`tape_options()`](https://schochastics.github.io/vhsR/reference/tape_options.md)
for the full pacing/styling argument list.

## Examples

``` r
if (FALSE) { # \dontrun{
record_demo({
  x <- 1:5
  mean(x)
  head(cars, 3)
}, output = "demo.gif")
} # }
```
