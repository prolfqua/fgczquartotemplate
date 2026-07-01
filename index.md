# fgczquartotemplate

Shared **Quarto report assets** for FGCZ analysis packages (`ezRun`,
`prolfqua`, …). It packages one common look-and-feel — a format YAML, an
SCSS theme, and an HTML header — plus a starter report template and
small helpers to stage those files next to a `.qmd` and render it.

The goal: keep the FGCZ report styling in **one place** so every package
that produces Quarto reports shares it and a theme change is a single
package bump.

## What’s inside

Installed under `inst/quarto/`:

| File                      | Role                                                                                     |
|---------------------------|------------------------------------------------------------------------------------------|
| `_fgcz-report.yml`        | Shared format defaults, pulled into a report via `metadata-files: ["_fgcz-report.yml"]`. |
| `fgcz.scss`               | Theme overrides — tabset/card styling, figure rows.                                      |
| `fgcz_header_quarto.html` | FGCZ header, injected via `include-in-header`.                                           |
| `template.qmd`            | Generic starter report demonstrating the tabset, figure+callout, and nesting patterns.   |

## Why a render wrapper (and not just an absolute path)

The three styling files reference each other by **bare filename**
(`theme: [spacelab, fgcz.scss]`,
`include-in-header: fgcz_header_quarto.html`), and Quarto resolves such
paths relative to the **input `.qmd`’s directory** — not relative to the
YAML that names them. So they must physically sit next to the `.qmd` at
render time.
[`fgcz_copy_assets()`](https://prolfqua.github.io/fgczquartotemplate/reference/fgcz_copy_assets.md)
/
[`fgcz_render()`](https://prolfqua.github.io/fgczquartotemplate/reference/fgcz_render.md)
put them there; the report’s header stays fully portable and never
hard-codes a path.

## Usage

Your report keeps exactly the header it has today:

``` yaml
---
params:
  reportTitle: "CountQC"
title: "`r params$reportTitle`"
metadata-files: ["_fgcz-report.yml"]
---
```

Render it through the wrapper — the shared assets are staged
automatically:

``` r
fgczquartotemplate::fgcz_render(
  "CountQC.qmd",
  execute_params = list(reportTitle = "CountQC")
)
```

Bootstrap a brand-new report from the starter template:

``` r
fgczquartotemplate::fgcz_use_template("reports/my_analysis",
                                      to = "my_analysis.qmd")
# edit reports/my_analysis/my_analysis.qmd, then:
fgczquartotemplate::fgcz_render("reports/my_analysis/my_analysis.qmd")
```

Just need the paths (e.g. to stage assets yourself)?

``` r
fgczquartotemplate::fgcz_quarto_dir()             # the inst/quarto directory
fgczquartotemplate::fgcz_copy_assets("some/dir")  # stage the 3 styling files
```

## Using it from ezRun / prolfqua

1.  Add `fgczquartotemplate` to `Imports` in the consumer’s
    `DESCRIPTION`.

2.  Replace ad-hoc `quarto_render()` calls with
    [`fgczquartotemplate::fgcz_render()`](https://prolfqua.github.io/fgczquartotemplate/reference/fgcz_render.md).

3.  In the consumer, **git-ignore the staged copies** so the packaged
    assets remain the single source of truth — add to the render
    directory’s `.gitignore`:

        _fgcz-report.yml
        fgcz.scss
        fgcz_header_quarto.html

App-specific reports (e.g. `CountQC.qmd`, `ScSeurat.qmd`) stay in their
own package; only the shared *styling* lives here.

## Installation

``` r
# from a local checkout
devtools::install("path/to/fgczquartotemplate")
```

## Requirements

- [Quarto](https://quarto.org/) on `PATH`
- R package `quarto`

## License

GPL-3 (matching `ezRun`).
