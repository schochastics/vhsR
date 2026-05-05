# Recording demos for a package README

``` r

library(vhsR)
```

The single most common reason to reach for vhsR is to ship an animated
demo at the top of a package’s README. This vignette walks through the
canonical workflow — from a fresh
[`record_demo()`](https://schochastics.github.io/vhsR/reference/record_demo.md)
call to a GIF that GitHub renders inline.

## The 30-second version

``` r

record_demo({
  x <- 1:5
  mean(x)
  head(cars, 3)
}, output = "man/figures/demo.gif")
```

Then in your `README.md` (or `README.Rmd`):

``` md
![](man/figures/demo.gif)
```

That’s it. The recording runs once on your machine, gets committed to
the repository, and renders inline on GitHub, pkgdown, and CRAN’s HTML
package page (where supported). Treat the GIF as you would any other
artefact under `man/figures/` — refresh it when the demo’s content
changes, otherwise leave it alone.

## Using `README.Rmd` and the `vhsr` knitr engine

If you maintain a `README.Rmd`, vhsR registers a `vhsr` knitr engine on
package load that records and image-includes in one step. Inside
`README.Rmd`:


    ``` vhsr
    x <- 1:5
    mean(x)
    head(cars, 3)
    ```

When you run `devtools::build_readme()` (or knit by hand), the chunk:

1.  records a GIF at `output=`;
2.  emits a markdown image-include in the rendered `README.md`.

Forwarded chunk options are `output`, `backend`, and any pacing or
styling argument accepted by
[`tape_options()`](https://schochastics.github.io/vhsR/reference/tape_options.md)
(e.g. `width`, `height`, `font_size`, `theme`, `typing_speed`,
`line_pause`, `start_pause`, `paragraph_pause`). See
[`?tape_options`](https://schochastics.github.io/vhsR/reference/tape_options.md)
for the full list. Anything else is ignored.

## Pipe chains type the way you wrote them

Multi-line `|>` pipelines record verbatim — the recording shows the pipe
form you typed, not the desugared nested-call form R’s parser produces
internally:

``` r

record_demo({
  library(dplyr)

  mtcars |>
    filter(cyl == 6) |>
    arrange(desc(mpg))
}, output = "man/figures/demo.gif")
```

Same goes for blank lines: an empty line between two statements stays
empty in the recording, which composes nicely with `paragraph_pause`
when you want a beat between sections.

## Where the GIF lives, and what to commit

`man/figures/` is the convention. roxygen, pkgdown, and CRAN’s package
page all know to look there. Commit the recorded GIF:

- Recording is slow (5–30 seconds per run) and CI typically doesn’t have
  vhs installed — there’s no point regenerating on every push.
- A committed GIF is bit-stable across clones, so a reader’s view of
  your README never depends on a CI artefact.
- When the demo content changes, refresh by re-running
  [`record_demo()`](https://schochastics.github.io/vhsR/reference/record_demo.md)
  (or rebuilding the README) and committing the new GIF.

A common make target keeps the workflow explicit:

``` make
demo: man/figures/demo.gif

man/figures/demo.gif: scripts/demo.R
    R -e 'vhsR::record_demo_file("scripts/demo.R", output = "$@")'
```

## File-size budget

GitHub renders inline GIFs up to about 10 MB but anything over 1–2 MB
starts to feel slow on a slow connection. To stay small:

- **Keep the demo short.** 4–8 lines of code is plenty.
- **Trim the dimensions.** `width = 1000, height = 500` is a good
  balance.
- **Speed up typing.** `typing_speed = "40ms"` (instead of the `"60ms"`
  default) shaves a meaningful amount of frames.

If the GIF is still too big, switch to `.mp4` or `.webm`:

``` r

record_demo({...}, output = "man/figures/demo.mp4")
```

GitHub’s README renderer doesn’t autoplay video, but pkgdown and any
HTML render do. Embed it with
[`vhsr_widget()`](https://schochastics.github.io/vhsR/reference/vhsr_widget.md):

``` r

vhsr_widget("man/figures/demo.mp4")
```

…which produces a `<video controls loop muted playsinline>` tag tree
suitable for a chunk with `results = "asis"`.

## Common gotchas

- **macOS install.**
  [`vhsr_install()`](https://schochastics.github.io/vhsR/reference/vhsr_install.md)
  auto-downloads `vhs` on macOS but prints `brew install` lines for
  `ttyd` and `ffmpeg` (those have no usable upstream binaries on macOS).
  The recorder doesn’t care whether the binaries came from brew or the
  cache.
- **CRAN doesn’t ship `man/figures/`.** Files there are only included in
  the built tarball if they’re referenced from a help page
  (`\figure{...}` in an `.Rd`). For a README image this almost never
  matters — the README on GitHub references the same file directly — but
  be aware if you also reference it from package documentation.
- **CI rarely has vhs.** Don’t let `devtools::check()` re-record the
  README at check time. The `eval = FALSE` chunks in this vignette,
  combined with committed figures, are the safe pattern.

## See also

- [`vignette("pacing-and-feel", package = "vhsR")`](https://schochastics.github.io/vhsR/articles/pacing-and-feel.md)
  — making a recording feel less robotic.
- [`vignette("tape-scripts", package = "vhsR")`](https://schochastics.github.io/vhsR/articles/tape-scripts.md)
  — when you outgrow
  [`record_demo()`](https://schochastics.github.io/vhsR/reference/record_demo.md).
- [`?record_demo`](https://schochastics.github.io/vhsR/reference/record_demo.md),
  [`?record_demo_file`](https://schochastics.github.io/vhsR/reference/record_demo_file.md),
  [`?vhsr_widget`](https://schochastics.github.io/vhsR/reference/vhsr_widget.md).
