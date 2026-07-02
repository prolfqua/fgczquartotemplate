# Render an FGCZ Quarto report

Stages the shared styling assets next to `input` (via
[`fgcz_copy_assets()`](https://prolfqua.github.io/fgczquartotemplate/reference/fgcz_copy_assets.md))
and then renders it with
[`quarto::quarto_render()`](https://quarto-dev.github.io/quarto-r/reference/quarto_render.html).
The `.qmd` needs no styling front matter at all: the staged
`_metadata.yml` is picked up by Quarto automatically, so the report
stays fully portable.

## Usage

``` r
fgcz_render(input, buttons = FALSE, ...)
```

## Arguments

- input:

  Path to the `.qmd` to render.

- buttons:

  Add the right-edge search + download toolbar (`fgcz-plot-finder.html`)
  to the report. Defaults to `FALSE`; pass `TRUE` to opt in. The toolbar
  ships with the package and is always staged next to `input`, but is
  only wired in (via `include-after-body`) when you ask for it here.

- ...:

  Passed on to
  [`quarto::quarto_render()`](https://quarto-dev.github.io/quarto-r/reference/quarto_render.html)
  (e.g. `execute_params`, `output_file`, `quarto_args`). A `metadata`
  list passed here is honored; `buttons = TRUE` merges
  `include-after-body` into it.

## Value

The value of
[`quarto::quarto_render()`](https://quarto-dev.github.io/quarto-r/reference/quarto_render.html),
invisibly.

## Examples

``` r
if (FALSE) { # \dontrun{
fgcz_render("CountQC.qmd", execute_params = list(reportTitle = "CountQC"))
fgcz_render("CountQC.qmd", buttons = TRUE) # with the Find/Save toolbar
} # }
```
