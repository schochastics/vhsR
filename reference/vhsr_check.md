# Check whether all required binaries are available

Silent variant: returns `TRUE` when `vhs`, `ttyd`, and `ffmpeg` can all
be located via
[`vhsr_vhs_path()`](https://schochastics.github.io/vhsR/reference/vhsr_paths.md)
/
[`vhsr_ttyd_path()`](https://schochastics.github.io/vhsR/reference/vhsr_paths.md)
/
[`vhsr_ffmpeg_path()`](https://schochastics.github.io/vhsR/reference/vhsr_paths.md),
`FALSE` otherwise. Used at the top of
[`record_demo()`](https://schochastics.github.io/vhsR/reference/record_demo.md)
to bail with an actionable error.

## Usage

``` r
vhsr_check()
```

## Value

`TRUE` or `FALSE`.
