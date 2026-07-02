# Using the FGCZ Quarto report templates

## What this package provides

`fgczquartotemplate` ships one shared set of Quarto report assets so
that FGCZ analysis packages (`ezRun`, `prolfqua`, …) all produce reports
with the same look and feel. A theme change becomes a single package
bump instead of an edit in every downstream package.

**See the layout live:**
<https://prolfqua.github.io/fgczquartotemplate/example-report.html> — a
full report rendered with the extension (tabsets, figure + callout rows,
nesting, lightbox). pkgdown re-themes its own articles (it forces
`theme: none` and its own template), so that standalone page — not this
article — is the faithful demonstration of the FGCZ layout. This article
explains how to *use* the templates.

## Two ways to use it

**Way 1 — Quarto extension** (plain `quarto render`, no R). Once per
project:

``` sh
quarto add prolfqua/fgczquartotemplate
```

then in the report header:

``` yaml
---
title: "My report"
format: fgczquartotemplate-html
---
```

**Way 2 — R helper** (stage the files from R, no `format:` line needed)
— the subject of the rest of this article. Both routes produce the same
report and can coexist in one repo.

The assets live under `inst/quarto/`:

``` r
list.files(fgcz_quarto_dir())
#> [1] "_metadata.yml"           "fgcz_header_quarto.html"
#> [3] "fgcz-plot-finder.html"   "fgcz.scss"              
#> [5] "template.qmd"
```

| File                      | Role                                                                            |
|---------------------------|---------------------------------------------------------------------------------|
| `_metadata.yml`           | Shared format defaults, applied automatically to every `.qmd` in the directory. |
| `fgcz.scss`               | Theme overrides — tabset/card styling, figure rows.                             |
| `fgcz_header_quarto.html` | FGCZ header, injected via `include-in-header`.                                  |
| `template.qmd`            | Generic starter report demonstrating the layout patterns.                       |

## Why the assets must sit next to the report

Quarto applies a file named `_metadata.yml` automatically to every
`.qmd` in its directory (and subdirectories) — that is how the styling
attaches without any front-matter reference. The file in turn names
`fgcz.scss` and `fgcz_header_quarto.html` by **bare filename**:

``` r
writeLines(head(readLines(fgcz_quarto_dir("_metadata.yml")), 30))
#> ## ─────────────────────────────────────────────────────────────
#> ## FGCZ Shared Report Defaults
#> ## Quarto applies this file automatically to every .qmd in this
#> ## directory (and subdirectories) because it is named _metadata.yml.
#> ## Individual reports need NO reference to it in their front matter.
#> ## Keep fgcz.scss and fgcz_header_quarto.html next to it.
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

Because `_metadata.yml` attaches by directory, a report carries **no**
FGCZ-specific front matter at all — just its own params and title:

``` yaml
---
params:
  reportTitle: "CountQC"
title: "`r params$reportTitle`"
---
```

Rendered with a bare `quarto render CountQC.qmd`, it still picks up the
full styling — the package need not even be installed, as long as the
three assets are in the directory.

## Staging the assets

[`fgcz_copy_assets()`](https://prolfqua.github.io/fgczquartotemplate/reference/fgcz_copy_assets.md)
copies the three styling files into a directory. Here we stage them into
a temporary directory and confirm they landed:

``` r
dir <- file.path(tempdir(), "demo-report")
dir.create(dir, showWarnings = FALSE)

staged <- fgcz_copy_assets(dir)
basename(staged)
#> [1] "_metadata.yml"           "fgcz.scss"              
#> [3] "fgcz_header_quarto.html" "fgcz-plot-finder.html"
file.exists(staged)
#> [1] TRUE TRUE TRUE TRUE
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
#> [1] "_metadata.yml"           "fgcz_header_quarto.html"
#> [3] "fgcz-plot-finder.html"   "fgcz.scss"              
#> [5] "my_report.qmd"
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
3.  Leave report front matter free of any styling reference — the staged
    `_metadata.yml` attaches automatically.
4.  Git-ignore the staged copies (`_metadata.yml`, `fgcz.scss`,
    `fgcz_header_quarto.html`) in the render directory so the packaged
    assets remain the single source of truth.
