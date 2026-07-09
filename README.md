# fgczquartotemplate

One shared **FGCZ look-and-feel** for Quarto reports (theme + header + defaults),
reusable across `ezRun`, `prolfqua`, `prolfquapp`, …. Reports can opt in to a
right-edge toolbar — **🔍 Find** any figure or table, browse them as a
**🖼️ Figures** thumbnail gallery, or **📥 Save** the plots as a ZIP.

**👉 [See the documentation site](https://prolfqua.github.io/fgczquartotemplate/)** — including a live example report with the real layout, tabsets, figures, and the Find / Figures / Save toolbar.

`fgczquartotemplate` is a **Quarto format extension**: add it once per project,
then select it in any report's YAML header.

---

## Use it

**Step 1.** In your project, once:

```sh
quarto add prolfqua/fgczquartotemplate
```

This creates `_extensions/fgczquartotemplate/` in the project. Without that
extension directory, `format: fgczquartotemplate-html` fails because Quarto
cannot resolve the custom format.

**Step 2.** In your report's YAML header:

```yaml
---
title: "My report"
format: fgczquartotemplate-html
---
```

**Step 3.** Render:

```sh
quarto render my_report.qmd
```

Done. ✅

**Optional — 🔍 Find / 🖼️ Figures / 📥 Save toolbar** (off by default). Switch it on per
report by adding one line to the header:

```yaml
format:
  fgczquartotemplate-html:
    include-after-body: _extensions/fgczquartotemplate/fgcz-plot-finder.html
```

---

## Vendoring in an R package

Downstream R packages that build reports at install or render time can **vendor**
the extension instead of running `quarto add`: copy
`_extensions/fgczquartotemplate/` into the report's directory (e.g.
`vignettes/_extensions/`) and commit it, so the styling travels with the package.
This repo's own `vignettes/example-report.qmd` does exactly that.

## What's in the extension

| File | Role |
|------|------|
| `_extension.yml` | Declares the `fgczquartotemplate-html` format and its options. |
| `fgcz.scss` | Theme overrides — tabset / card styling, figure rows. |
| `fgcz_header_quarto.html` | The FGCZ header, injected via `include-in-header`. |
| `fgcz-plot-finder.html` | The opt-in 🔍 Find / 🖼️ Figures / 📥 Save toolbar. |

## For maintainers

- The single source of the extension is `_extensions/fgczquartotemplate/` (what
  `quarto add` fetches). After editing it, run `make sync` to mirror it into
  `vignettes/_extensions/` so the demo vignette builds against the same files.
- The live example report is `vignettes/example-report.qmd`; the documentation
  site (built with `altdoc` — `make site`) renders it through Quarto with its
  tabsets intact.

## License

GPL (>= 3), matching `ezRun`.
