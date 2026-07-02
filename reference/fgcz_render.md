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
fgcz_render(input, ...)
```

## Arguments

- input:

  Path to the `.qmd` to render.

- ...:

  Passed on to
  [`quarto::quarto_render()`](https://quarto-dev.github.io/quarto-r/reference/quarto_render.html)
  (e.g. `execute_params`, `output_file`, `quarto_args`).

## Value

The value of
[`quarto::quarto_render()`](https://quarto-dev.github.io/quarto-r/reference/quarto_render.html),
invisibly.

## Examples

``` r
if (FALSE) { # \dontrun{
fgcz_render("CountQC.qmd", execute_params = list(reportTitle = "CountQC"))
} # }
```
