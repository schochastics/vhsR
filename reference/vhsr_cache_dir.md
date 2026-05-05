# Locate the per-user vhsR binary cache

The directory under
[`tools::R_user_dir()`](https://rdrr.io/r/tools/userdir.html) where
[`vhsr_install()`](https://schochastics.github.io/vhsR/reference/vhsr_install.md)
places downloaded `vhs`, `ttyd`, and `ffmpeg` binaries. The path is
platform-and-architecture-specific so a single `$HOME` can serve
multiple machines (e.g. via NFS).

## Usage

``` r
vhsr_cache_dir()
```

## Value

A length-1 character path. The directory is not created on read.
