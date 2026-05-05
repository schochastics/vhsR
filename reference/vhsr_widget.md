# Embed a vhsR recording as an HTML widget

Returns an
[`htmltools::tagList()`](https://rstudio.github.io/htmltools/reference/tagList.html)
containing the recorded GIF / video, suitable for embedding in an
Rmarkdown chunk (`results = "asis"`) or a Shiny UI. Auto-detects the
format from `file`'s extension: `.gif` becomes a styled `<img>`, `.mp4`
/ `.webm` become a `<video controls loop muted playsinline>`.

## Usage

``` r
vhsr_widget(file, width = NULL, height = NULL)
```

## Arguments

- file:

  Path to a `.gif`, `.mp4`, or `.webm` file produced by
  [`record_demo()`](https://schochastics.github.io/vhsR/reference/record_demo.md)
  /
  [`vhsr_run_tape()`](https://schochastics.github.io/vhsR/reference/vhsr_run_tape.md).

- width, height:

  Optional CSS dimensions. Numeric values are treated as pixels (e.g.
  `800` → `"800px"`); strings pass through verbatim (e.g. `"100%"`).

## Value

An
[`htmltools::tagList`](https://rstudio.github.io/htmltools/reference/tagList.html).

## Examples

``` r
if (FALSE) { # \dontrun{
record_demo({ x <- 1:5; mean(x) }, output = "demo.gif")
vhsr_widget("demo.gif")
} # }
```
