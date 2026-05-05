# Install vhs and its runtime dependencies

Downloads `vhs`, `ttyd`, and `ffmpeg` into the per-user cache returned
by
[`vhsr_cache_dir()`](https://schochastics.github.io/vhsR/reference/vhsr_cache_dir.md).
Where binaries cannot be auto-downloaded for a given platform (notably
`ttyd` and `ffmpeg` on macOS), the function aborts with a one-line
`brew install` instruction; system-installed binaries on `PATH` are
picked up automatically by
[`vhsr_doctor()`](https://schochastics.github.io/vhsR/reference/vhsr_doctor.md)
afterwards.

## Usage

``` r
vhsr_install(
  tools = c("vhs", "ttyd", "ffmpeg"),
  force = FALSE,
  versions = list()
)
```

## Arguments

- tools:

  Character vector of tools to install. Defaults to all three.

- force:

  If `TRUE`, re-download even if the binary already exists.

- versions:

  A named list overriding the default version of any tool, for example
  `list(vhs = "0.10.0")`.

## Value

Invisibly returns the cache directory path.
