## Keep the two distribution channels consistent.
##
## Single source of truth: inst/quarto/
##   - Model A (R): fgcz_copy_assets() stages inst/quarto/{_metadata.yml, scss, header}
##   - Model B (Quarto extension): _extensions/fgczquartotemplate/ ships scss + header
##                                 and _extension.yml (same options, nested)
##
## This script (1) copies fgcz.scss + fgcz_header_quarto.html from inst/quarto/
## into the extension, and (2) asserts the FORMAT OPTIONS in inst/quarto/_metadata.yml
## match those under contributes.formats.html in the extension's _extension.yml.
## Run it after editing any of those files, then commit. CI re-runs it and fails
## on any git change or option mismatch.
##
##   Rscript data-raw/sync_assets.R

dest_dir <- file.path("_extensions", "fgczquartotemplate")
stopifnot(dir.exists(dest_dir), dir.exists(file.path("inst", "quarto")))

## (1) Sync the byte-identical shared files ----------------------------------
shared <- c("fgcz.scss", "fgcz_header_quarto.html", "fgcz-plot-finder.html")
src <- file.path("inst", "quarto", shared)
stopifnot(all(file.exists(src)))
ok <- file.copy(src, dest_dir, overwrite = TRUE)
if (!all(ok)) {
  stop("Failed to sync: ", paste(shared[!ok], collapse = ", "))
}
for (f in shared) {
  a <- readBin(file.path("inst", "quarto", f), "raw", n = 1e7)
  b <- readBin(file.path(dest_dir, f), "raw", n = 1e7)
  if (!identical(a, b)) stop("Out of sync after copy: ", f)
}

## (2) Assert the format options agree between the two channels ----------------
if (!requireNamespace("yaml", quietly = TRUE)) {
  stop("Package 'yaml' is required to check _metadata.yml vs _extension.yml.")
}
meta <- yaml::read_yaml(file.path("inst", "quarto", "_metadata.yml"))
ext <- yaml::read_yaml(file.path(dest_dir, "_extension.yml"))

# _metadata.yml keeps execute/knitr/crossref/lightbox at the top level (applied
# document-wide); the extension nests them inside the contributed html format.
meta_html <- meta$format$html
for (k in c("execute", "knitr", "crossref", "lightbox")) {
  meta_html[[k]] <- meta[[k]]
}
ext_html <- ext$contributes$formats$html

# Order-independent deep comparison of the two option trees.
norm <- function(x) {
  if (is.list(x)) {
    nm <- names(x)
    if (!is.null(nm)) {
      x <- x[order(nm)]
    }
    lapply(x, norm)
  } else {
    x
  }
}
if (!identical(norm(meta_html), norm(ext_html))) {
  only_meta <- setdiff(names(meta_html), names(ext_html))
  only_ext <- setdiff(names(ext_html), names(meta_html))
  common <- intersect(names(meta_html), names(ext_html))
  diffkeys <- common[
    !vapply(
      common,
      function(k) identical(norm(meta_html[[k]]), norm(ext_html[[k]])),
      logical(1)
    )
  ]
  stop(
    "Format options differ between inst/quarto/_metadata.yml and ",
    dest_dir,
    "/_extension.yml.\n",
    if (length(only_meta)) {
      paste0(
        "  only in _metadata.yml: ",
        paste(only_meta, collapse = ", "),
        "\n"
      )
    },
    if (length(only_ext)) {
      paste0(
        "  only in _extension.yml: ",
        paste(only_ext, collapse = ", "),
        "\n"
      )
    },
    if (length(diffkeys)) {
      paste0("  differing values for: ", paste(diffkeys, collapse = ", "), "\n")
    },
    "Reconcile them by hand so both channels render identically."
  )
}

## (3) Mirror the finished extension into vignettes/ -------------------------
## The packaged demo vignette (vignettes/_example-report.qmd) renders with
## `format: fgczquartotemplate-html`, so it needs the extension next to it at
## R CMD build time. Keep inst/quarto/ as the single source: this mirrors the
## already-synced _extensions/ tree into vignettes/_extensions/ verbatim.
vig_ext <- file.path("vignettes", "_extensions", "fgczquartotemplate")
dir.create(vig_ext, recursive = TRUE, showWarnings = FALSE)
ext_files <- list.files(dest_dir, full.names = TRUE)
ok3 <- file.copy(ext_files, vig_ext, overwrite = TRUE)
if (!all(ok3)) {
  stop("Failed to mirror extension into ", vig_ext)
}
for (f in basename(ext_files)) {
  a <- readBin(file.path(dest_dir, f), "raw", n = 1e7)
  b <- readBin(file.path(vig_ext, f), "raw", n = 1e7)
  if (!identical(a, b)) stop("Out of sync after mirror: vignettes copy of ", f)
}

## The vignette and copied starter use the same visual abstract. Keep its
## packaged copy in inst/quarto/ as the source of truth too.
overview <- "fgcz-report-overview.svg"
overview_src <- file.path("inst", "quarto", overview)
overview_vignette <- file.path("vignettes", overview)
if (!file.copy(overview_src, overview_vignette, overwrite = TRUE)) {
  stop("Failed to mirror ", overview, " into vignettes/.")
}
if (
  !identical(
    readBin(overview_src, "raw", n = 1e7),
    readBin(overview_vignette, "raw", n = 1e7)
  )
) {
  stop("Out of sync after mirror: vignettes copy of ", overview)
}

## The required report shell is part of the documented contract. Validate both
## author-facing examples so later edits cannot silently drift from the skill.
validate_report_layout <- function(path) {
  qmd <- trimws(readLines(path, warn = FALSE))
  top_level <- grep("^# ", qmd, value = TRUE)
  session_info <- match("# Session Info", qmd)
  if (
    length(top_level) < 2 ||
      top_level[[1]] != "# Overview" ||
      tail(top_level, 1) != "# Session Info" ||
      is.na(session_info)
  ) {
    stop(path, " must start with Overview and end with Session Info.")
  }
  session_subtabs <- grep(
    "^## ",
    qmd[session_info:length(qmd)],
    value = TRUE
  )
  expected <- c("## Report provenance", "## R session info")
  if (!identical(session_subtabs, expected)) {
    stop(path, " must contain exactly the required Session Info subtabs.")
  }
  if (!any(grepl(overview, qmd, fixed = TRUE))) {
    stop(path, " must reference ", overview, ".")
  }
}

invisible(lapply(
  c(
    file.path("inst", "quarto", "template.qmd"),
    file.path("vignettes", "example-report.qmd")
  ),
  validate_report_layout
))

message(
  "OK: synced ",
  paste(shared, collapse = ", "),
  ", mirrored the extension and visual abstract into vignettes/, and verified ",
  "_metadata.yml <-> _extension.yml format options match."
)
