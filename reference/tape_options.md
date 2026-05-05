# Pacing and styling options for a vhsR recording

Constructor for the option list passed to internal recording helpers.
Public entry points like
[`record_demo()`](https://schochastics.github.io/vhsR/reference/record_demo.md)
forward `...` here, so any argument documented below can be passed by
name to those functions. Calling `tape_options()` directly with an
unknown argument errors out, which gives the public functions typo
safety on pacing/styling args.

## Usage

``` r
tape_options(
  width = 1200,
  height = 600,
  font_size = 22,
  theme = "Catppuccin Mocha",
  typing_speed = "60ms",
  playback_speed = 1,
  line_pause = "500ms",
  start_pause = "800ms",
  end_pause = "500ms",
  paragraph_pause = NULL,
  typing_speed_jitter = 0
)
```

## Arguments

- width, height:

  Terminal dimensions in pixels.

- font_size:

  Font size in pixels.

- theme:

  A vhs theme name.

- typing_speed:

  Per-keystroke delay, e.g. `"60ms"`.

- playback_speed:

  Playback rate multiplier (1 = real time).

- line_pause:

  Delay after each line of R code, e.g. `"500ms"`.

- start_pause:

  Delay between R startup and the first typed line.

- end_pause:

  Delay between the last typed line and the (hidden)
  [`q()`](https://rdrr.io/r/base/quit.html) exit.

- paragraph_pause:

  If set, blank lines produce a sleep of this duration instead of being
  typed.

- typing_speed_jitter:

  Numeric in `[0, 1]`; when positive, each typed line uses a speed
  sampled uniformly within `±jitter` of `typing_speed`.

## Value

A named list of options.
