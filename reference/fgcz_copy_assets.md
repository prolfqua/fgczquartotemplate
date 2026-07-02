# Copy the shared report assets next to a `.qmd`

Copies the shared styling files (`_metadata.yml`, `fgcz.scss`,
`fgcz_header_quarto.html`, `fgcz-plot-finder.html`) from the installed
package next to a report. `path` may be either an existing directory, or
an existing `.qmd` file whose containing directory should receive the
assets. Because `_metadata.yml` is directory metadata, any `.qmd` in the
target directory then renders with the FGCZ styling (and the search +
download toolbar) automatically. Call this before rendering, or use
[`fgcz_render()`](https://prolfqua.github.io/fgczquartotemplate/reference/fgcz_render.md),
which calls it for you.

## Usage

``` r
fgcz_copy_assets(path, overwrite = TRUE)
```

## Arguments

- path:

  An existing directory to stage the assets into, or a path to the
  `.qmd` itself (assets go into its containing directory).

- overwrite:

  Overwrite existing copies in the target directory. Defaults to `TRUE`
  so the packaged assets stay the single source of truth.

## Value

Character vector of the copied file paths, invisibly.

## Examples

``` r
if (FALSE) { # \dontrun{
fgcz_copy_assets("path/to/report/dir")
fgcz_copy_assets("path/to/report.qmd")
} # }
```
