# The names of the shared styling assets

The files that every FGCZ report needs alongside it: the directory
metadata (`_metadata.yml`), the SCSS theme, the HTML header, and the
search + download toolbar. The first three are wired in by
`_metadata.yml`; the toolbar is staged too but stays opt-in (see
[`fgcz_render()`](https://prolfqua.github.io/fgczquartotemplate/reference/fgcz_render.md)'s
`buttons` argument). `template.qmd` is deliberately excluded – it is a
starter you copy once, not an asset staged on every render.

## Usage

``` r
.fgcz_style_assets
```

## Format

An object of class `character` of length 4.
