# Copy the shared report assets next to a `.qmd`

Copies `_metadata.yml`, `fgcz.scss` and `fgcz_header_quarto.html` from
the installed package into `dir`. Because `_metadata.yml` is directory
metadata, any `.qmd` in `dir` then renders with the FGCZ styling
automatically. Call this before rendering, or use
[`fgcz_render()`](https://prolfqua.github.io/fgczquartotemplate/reference/fgcz_render.md),
which calls it for you.

## Usage

``` r
fgcz_copy_assets(dir, overwrite = TRUE)
```

## Arguments

- dir:

  Directory that contains (or will contain) the `.qmd` to render.

- overwrite:

  Overwrite existing copies in `dir`. Defaults to `TRUE` so the packaged
  assets stay the single source of truth.

## Value

Character vector of the copied file paths, invisibly.

## Examples

``` r
if (FALSE) { # \dontrun{
fgcz_copy_assets("path/to/report/dir")
} # }
```
