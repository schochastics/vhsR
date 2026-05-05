# Resolve paths to vhs and its dependencies

Each function returns the first match in this order: option
(`vhsR.<tool>_path`) -\> env var (`VHSR_<TOOL>`) -\> per-user cache (see
[`vhsr_cache_dir()`](https://schochastics.github.io/vhsR/reference/vhsr_cache_dir.md))
-\> system `PATH`. Returns `""` when nothing matches.

## Usage

``` r
vhsr_vhs_path()

vhsr_ttyd_path()

vhsr_ffmpeg_path()

vhsr_radian_path()

vhsr_arf_path()
```

## Value

A length-1 character path, or `""` if not found.
