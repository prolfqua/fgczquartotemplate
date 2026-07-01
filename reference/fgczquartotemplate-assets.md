# Shared FGCZ Quarto report assets

The package ships a common set of Quarto report assets under
`inst/quarto/` so that FGCZ analysis packages (ezRun, prolfqua, ...)
share one look and feel:

## Details

- `_fgcz-report.yml`:

  Shared format defaults, included from a `.qmd` via
  `metadata-files: ["_fgcz-report.yml"]`.

- `fgcz.scss`:

  Theme overrides (tabset/card styling, figure rows).

- `fgcz_header_quarto.html`:

  FGCZ header injected via `include-in-header`.

- `template.qmd`:

  A generic starter report demonstrating the tabset,
  figure-with-callout, and nesting patterns.

These three styling files reference each other by **bare filename**, and
Quarto resolves such paths relative to the directory of the input
`.qmd`. They must therefore sit next to the `.qmd` at render time; see
[`fgcz_copy_assets()`](https://prolfqua.github.io/fgczquartotemplate/reference/fgcz_copy_assets.md)
and
[`fgcz_render()`](https://prolfqua.github.io/fgczquartotemplate/reference/fgcz_render.md).
