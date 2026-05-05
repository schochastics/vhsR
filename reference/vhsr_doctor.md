# Report on the state of vhs and its dependencies

Prints two sections. The required binaries (`vhs`, `ttyd`, `ffmpeg`) are
reported one per line with name, version, where they were found (cache
or system), and full path. The optional highlighting tools (`arf`,
`radian`) are reported below with install hints when missing. If any
required binary is missing, a one-line
[`vhsr_install()`](https://schochastics.github.io/vhsR/reference/vhsr_install.md)
call is suggested at the end.

## Usage

``` r
vhsr_doctor()
```

## Value

Invisibly returns the result of
[`vhsr_check()`](https://schochastics.github.io/vhsR/reference/vhsr_check.md).
