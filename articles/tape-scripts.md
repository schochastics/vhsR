# Hand-writing tape scripts

``` r

library(vhsR)
```

[`record_demo()`](https://schochastics.github.io/vhsR/reference/record_demo.md)
and friends cover the typical case — type a block of R code into a real
REPL, get a GIF. When you outgrow that, the underlying
[charmbracelet/vhs](https://github.com/charmbracelet/vhs) tape syntax is
more general than
[`record_demo()`](https://schochastics.github.io/vhsR/reference/record_demo.md)
exposes. This vignette walks through the primitives you’ll want, the
corners that bite, and how to hand a tape file or string to
[`vhsr_run_tape()`](https://schochastics.github.io/vhsR/reference/vhsr_run_tape.md).

## When to leave `record_demo()` behind

[`record_demo()`](https://schochastics.github.io/vhsR/reference/record_demo.md)
assumes you want to type R into a freshly-spawned R REPL. Reach for
hand-written tape when:

- You want to record a **shell session** (git, npm, pip, …) rather than
  R code.
- You need **multi-shell setup before R starts** — clearing the screen,
  exporting an environment variable, navigating into a project
  directory.
- You want **fine-grained timing**: per-key `Backspace` corrections,
  arrow-key navigation, `Wait /regex/` synchronisation against output.
- You want **multiple `Screenshot` directives** in a single recording
  for a flipbook.

For everything else,
[`record_demo()`](https://schochastics.github.io/vhsR/reference/record_demo.md)
saves typing.

## The primitives, R-flavoured

The full vhs tape reference lives at the [charmbracelet/vhs
README](https://github.com/charmbracelet/vhs#vhs-command-reference);
this is a working subset.

### Set: terminal configuration

    Set Shell    "bash"
    Set FontSize 22
    Set Width    1200
    Set Height   600
    Set Theme    "Catppuccin Mocha"
    Set TypingSpeed 60ms

`Set` directives must come before any input (`Type`, `Enter`, …).
[`record_demo()`](https://schochastics.github.io/vhsR/reference/record_demo.md)
always emits them at the top of the tape.

### Type: simulated keystrokes

    Type "echo Hello"

`Type@<duration>` overrides the global `TypingSpeed` for one line:

    Type@30ms "this types at 30ms per char"

vhsR uses this for `typing_speed_jitter`.

### Keys

    Enter
    Enter 3            # press Enter three times
    Backspace 5
    Tab
    Space
    Up    / Down / Left / Right
    Ctrl+C

### Sleep and Wait

    Sleep 800ms
    Sleep 2s

`Wait /regex/` blocks until the on-screen content matches:

    Type "long-running-command"
    Enter
    Wait /Done\.$/    # waits up to 15s by default

Useful when the next typed input would be too early — for instance,
waiting for an R prompt to redraw before continuing.

### Hide / Show

    Hide
    Type "stuff that shouldn't appear in the recording"
    Enter
    Show

`Hide` does **not** pause execution. The shell still runs typed input;
vhs just stops adding frames to the output.
[`record_demo()`](https://schochastics.github.io/vhsR/reference/record_demo.md)
uses this to hide the `R --quiet --no-save` (or `arf`, or `radian`)
startup.

### Source, Env, Screenshot

    Source "common-setup.tape"     # include another tape file
    Env DEMO_VAR "true"            # env var for the spawned shell
    Screenshot "frame.png"         # save a PNG of the current frame

`Screenshot` is what
[`record_demo_screenshot()`](https://schochastics.github.io/vhsR/reference/record_demo_screenshot.md)
calls through to.

## Gotchas vhsR works around for you

Three corners of vhs tape syntax that vhsR papers over internally;
you’ll want to copy the pattern when writing tape by hand.

1.  **Slashes in unquoted paths look like a `Wait` regex literal.** vhs
    parses `/something/` as a regex. So this fails:

        Output /tmp/demo.gif
        Screenshot /tmp/frame.png

    Quote the paths:

        Output "/tmp/demo.gif"
        Screenshot "/tmp/frame.png"

2.  **Strings with double quotes inside `Type`** need backtick fallback:

        Type "x <- \"hello\""    # broken — vhs doesn't handle the escape
        Type `x <- "hello"`      # works — vhs treats backticks as quotes

    `vhsR:::quote_for_tape()` picks the right form per line.

3.  **`Screenshot` is occasionally racy.** vhs takes the screenshot the
    moment the directive runs in the tape, but the headless renderer
    sometimes hasn’t repainted yet. Leave a `Sleep 200ms` (or longer)
    immediately before each `Screenshot` to be safe.

## Running a hand-written tape

Pass a file path:

``` r

vhsr_run_tape("scripts/my-demo.tape")
```

…or a multi-line string:

``` r

vhsr_run_tape('
Output "demo.gif"
Set Shell "bash"
Set FontSize 22
Type "echo Hello from a hand-written tape!"
Enter
Sleep 800ms
Type `ls -1 *.R | head -3`
Enter
Sleep 1s
')
```

Both code paths go through the same vhs binary as
[`record_demo()`](https://schochastics.github.io/vhsR/reference/record_demo.md),
with the same
[`vhsr_check()`](https://schochastics.github.io/vhsR/reference/vhsr_check.md)
gate and the same path resolution
([`vhsr_vhs_path()`](https://schochastics.github.io/vhsR/reference/vhsr_paths.md)
etc.). Anything you can express in tape syntax, this function can run.

The example above produces:

![](figures/tape-hello.gif)

## Version pinning

vhsR’s
[`vhsr_install()`](https://schochastics.github.io/vhsR/reference/vhsr_install.md)
pins to a specific upstream vhs version (`DEFAULT_VHS_VERSION` in
`R/install.R`). If you’ve written tape that relies on a newer vhs
feature, install that version explicitly:

``` r

vhsr_install(versions = list(vhs = "0.12.0"))
```

…or point at a system-installed vhs by setting `vhsR.vhs_path` /
`VHSR_VHS`. See
[`?vhsr_vhs_path`](https://schochastics.github.io/vhsR/reference/vhsr_paths.md)
for the resolution chain.

## See also

- vhs’s full primitive list:
  <https://github.com/charmbracelet/vhs#vhs-command-reference>
- [`?vhsr_run_tape`](https://schochastics.github.io/vhsR/reference/vhsr_run_tape.md),
  [`?vhsr_install`](https://schochastics.github.io/vhsR/reference/vhsr_install.md),
  [`?vhsr_vhs_path`](https://schochastics.github.io/vhsR/reference/vhsr_paths.md).
- [`vignette("recording-for-readme", package = "vhsR")`](https://schochastics.github.io/vhsR/articles/recording-for-readme.md)
  and
  [`vignette("pacing-and-feel", package = "vhsR")`](https://schochastics.github.io/vhsR/articles/pacing-and-feel.md)
  for the typical-case workflows.
