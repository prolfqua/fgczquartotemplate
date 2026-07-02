# Shared FGCZ Quarto report assets

The package ships a common set of Quarto report assets under
`inst/quarto/` so that FGCZ analysis packages (ezRun, prolfqua, ...)
share one look and feel:

## Details

- `_metadata.yml`:

  Shared format defaults. Quarto applies this file automatically to
  every `.qmd` in its directory (and subdirectories) because of its
  reserved name – reports need no reference to it.

- `fgcz.scss`:

  Theme overrides (tabset/card styling, figure rows).

- `fgcz_header_quarto.html`:

  FGCZ header injected via `include-in-header`.

- `template.qmd`:

  A generic starter report demonstrating the tabset,
  figure-with-callout, and nesting patterns.

Because `_metadata.yml` is applied by directory, a `.qmd` rendered with
a plain `quarto render` picks up the FGCZ styling with **no package
involved and no front-matter reference** – as long as these three files
sit in the same directory. The `_metadata.yml` references `fgcz.scss`
and `fgcz_header_quarto.html` by bare filename, which Quarto resolves
relative to the input `.qmd`, so all three must travel together; see
[`fgcz_copy_assets()`](https://prolfqua.github.io/fgczquartotemplate/reference/fgcz_copy_assets.md)
and
[`fgcz_render()`](https://prolfqua.github.io/fgczquartotemplate/reference/fgcz_render.md).
