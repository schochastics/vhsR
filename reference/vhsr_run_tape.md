# Run a hand-written tape script

Escape hatch for users who want full control over the vhs script. Pass
either a path to a `.tape` file or the tape contents as a string.

## Usage

``` r
vhsr_run_tape(tape, quiet = FALSE)
```

## Arguments

- tape:

  Path to a `.tape` file, or a string containing tape syntax.

- quiet:

  If `TRUE`, suppress vhs stdout/stderr.

## Value

Invisibly returns the
[`processx::run()`](http://processx.r-lib.org/reference/run.md) result.
