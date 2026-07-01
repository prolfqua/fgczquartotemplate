# Using the FGCZ Quarto report templates

## What this package provides

`fgczquartotemplate` ships one shared set of Quarto report assets so
that FGCZ analysis packages (`ezRun`, `prolfqua`, …) all produce reports
with the same look and feel. A theme change becomes a single package
bump instead of an edit in every downstream package.

The assets live under `inst/quarto/`:

``` r
list.files(fgcz_quarto_dir())
#> [1] "_fgcz-report.yml"        "fgcz_header_quarto.html"
#> [3] "fgcz.scss"               "template.qmd"
```

| File                      | Role                                                               |
|---------------------------|--------------------------------------------------------------------|
| `_fgcz-report.yml`        | Shared format defaults, pulled into a report via `metadata-files`. |
| `fgcz.scss`               | Theme overrides — tabset/card styling, figure rows.                |
| `fgcz_header_quarto.html` | FGCZ header, injected via `include-in-header`.                     |
| `template.qmd`            | Generic starter report demonstrating the layout patterns.          |

## Why the assets must sit next to the report

The three styling files reference each other by **bare filename** — the
format YAML names `fgcz.scss` and `fgcz_header_quarto.html`:

``` r
writeLines(head(readLines(fgcz_quarto_dir("_fgcz-report.yml")), 30))
#> ## ─────────────────────────────────────────────────────────────
#> ## FGCZ Shared Report Defaults
#> ## Include in individual .qmd files via:
#> ##   metadata-files: ["_fgcz-report.yml"]
#> ## ─────────────────────────────────────────────────────────────
#> 
#> format:
#>   html:
#>     embed-resources: true
#>     self-contained: true
#>     smooth-scroll: true
#>     page-layout: full
#> 
#>     # Code
#>     code-fold: true
#>     code-tools: true
#> 
#>     # Theme — flatly base + FGCZ overrides (tabset card styling for now)
#>     theme: [spacelab, fgcz.scss]
#> 
#>     # Grid sizing
#>     grid:
#>       body-width: 1800px
#>       sidebar-width: 250px
#>       margin-width: 100px
#> 
#>     # FGCZ header
#>     include-in-header: fgcz_header_quarto.html
#> 
#>     # Figure defaults
```

Quarto resolves those names relative to the directory of the **input
`.qmd`**, not relative to the YAML that mentions them. So all three
files must physically sit next to the report at render time. That is
exactly what
[`fgcz_copy_assets()`](https://prolfqua.github.io/fgczquartotemplate/reference/fgcz_copy_assets.md)
and
[`fgcz_render()`](https://prolfqua.github.io/fgczquartotemplate/reference/fgcz_render.md)
take care of.

## The portable report header

A report never hard-codes a path into the package. It keeps the same
header it would have if the assets were local:

``` yaml
---
params:
  reportTitle: "CountQC"
title: "`r params$reportTitle`"
metadata-files: ["_fgcz-report.yml"]
---
```

## Staging the assets

[`fgcz_copy_assets()`](https://prolfqua.github.io/fgczquartotemplate/reference/fgcz_copy_assets.md)
copies the three styling files into a directory. Here we stage them into
a temporary directory and confirm they landed:

``` r
dir <- file.path(tempdir(), "demo-report")
dir.create(dir, showWarnings = FALSE)

staged <- fgcz_copy_assets(dir)
basename(staged)
#> [1] "_fgcz-report.yml"        "fgcz.scss"              
#> [3] "fgcz_header_quarto.html"
file.exists(staged)
#> [1] TRUE TRUE TRUE
```

## Bootstrapping a new report

[`fgcz_use_template()`](https://prolfqua.github.io/fgczquartotemplate/reference/fgcz_use_template.md)
copies the starter `template.qmd` into a directory together with the
styling assets it needs, so you have a runnable report in one call:

``` r
qmd <- fgcz_use_template(file.path(tempdir(), "new-report"),
                         to = "my_report.qmd",
                         overwrite = TRUE)
list.files(dirname(qmd))
#> [1] "_fgcz-report.yml"        "fgcz_header_quarto.html"
#> [3] "fgcz.scss"               "my_report.qmd"
```

## Rendering

[`fgcz_render()`](https://prolfqua.github.io/fgczquartotemplate/reference/fgcz_render.md)
stages the assets and then calls
[`quarto::quarto_render()`](https://quarto-dev.github.io/quarto-r/reference/quarto_render.html).
It needs the Quarto CLI, so the call below is shown but not run in this
vignette:

``` r
fgcz_render(qmd, execute_params = list(reportTitle = "My analysis"))
```

That is the single call downstream packages use in place of a bare
[`quarto::quarto_render()`](https://quarto-dev.github.io/quarto-r/reference/quarto_render.html).

## Using it from a downstream package

1.  Add `fgczquartotemplate` to `Imports` (and, since it is distributed
    on GitHub, `Remotes: prolfqua/fgczquartotemplate`).
2.  Replace
    [`quarto::quarto_render()`](https://quarto-dev.github.io/quarto-r/reference/quarto_render.html)
    calls with
    [`fgczquartotemplate::fgcz_render()`](https://prolfqua.github.io/fgczquartotemplate/reference/fgcz_render.md).
3.  Keep report headers as `metadata-files: ["_fgcz-report.yml"]`.
4.  Git-ignore the staged copies in the render directory so the packaged
    assets remain the single source of truth.
