# Capture a single PNG frame from a recorded R session

Records the same R expression that
[`record_demo()`](https://schochastics.github.io/vhsR/reference/record_demo.md)
would, but instead of (or in addition to) the animated output, writes a
single PNG frame using vhs's `Screenshot` directive.

## Usage

``` r
record_demo_screenshot(
  expr,
  output = "demo.png",
  at = NULL,
  ...,
  backend = c("auto", "arf", "radian", "R"),
  quiet = FALSE
)
```

## Arguments

- expr:

  An R expression. See
  [`record_demo()`](https://schochastics.github.io/vhsR/reference/record_demo.md).

- output:

  Path to the output PNG. Must end in `.png`.

- at:

  Where to take the screenshot. `NULL` (default) → after the last typed
  line. A string `"after:N"` (1-indexed) → after the Nth line.

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
record_demo_screenshot(
  { x <- 1:5; mean(x) },
  output = "demo.png"
)
} # }
```
