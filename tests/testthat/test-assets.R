test_that("fgcz_copy_assets copies assets into a directory", {
  dir <- tempfile()
  dir.create(dir)
  expected_files <- c(
    "_metadata.yml",
    "fgcz.scss",
    "fgcz_header_quarto.html",
    "fgcz-plot-finder.html"
  )

  paths <- fgcz_copy_assets(dir)

  expect_setequal(basename(paths), expected_files)
  expect_equal(file.exists(paths), rep(TRUE, length(paths)))
  expect_equal(dirname(paths), rep(normalizePath(dir), length(paths)))
})

test_that("fgcz_copy_assets accepts a qmd file path", {
  dir <- tempfile()
  dir.create(dir)
  qmd <- file.path(dir, "report.qmd")
  expect_equal(file.create(qmd), TRUE)

  paths <- fgcz_copy_assets(qmd)

  expect_equal(file.exists(paths), rep(TRUE, length(paths)))
  expect_equal(dirname(paths), rep(normalizePath(dir), length(paths)))
})

test_that("fgcz_use_template copies the report skeleton and visual abstract", {
  dir <- tempfile()

  qmd <- fgcz_use_template(dir, to = "report.qmd")

  expect_equal(qmd, file.path(dir, "report.qmd"))
  expect_equal(
    file.exists(file.path(dir, "fgcz-report-overview.svg")),
    TRUE
  )
})

test_that("the starter follows the required analysis-report layout", {
  qmd <- trimws(readLines(fgcz_quarto_dir("template.qmd"), warn = FALSE))
  top_level <- grep("^# ", qmd, value = TRUE)
  session_info <- match("# Session Info", qmd)
  session_subtabs <- grep(
    "^## ",
    qmd[session_info:length(qmd)],
    value = TRUE
  )

  expect_equal(top_level[[1]], "# Overview")
  expect_equal(tail(top_level, 1), "# Session Info")
  expect_equal(
    session_subtabs,
    c("## Report provenance", "## R session info")
  )
  expect_equal(any(grepl("fgcz-report-overview.svg", qmd, fixed = TRUE)), TRUE)
})

test_that("fgcz_copy_assets rejects non-qmd file paths", {
  dir <- tempfile()
  dir.create(dir)
  txt <- file.path(dir, "report.txt")
  expect_equal(file.create(txt), TRUE)

  expect_snapshot(error = TRUE, fgcz_copy_assets(txt))
})

test_that("fgcz_render rejects a non-scalar-logical buttons", {
  # The buttons check runs before the quarto / file-existence checks, so this
  # needs neither quarto installed nor a real .qmd.
  expect_error(fgcz_render("x.qmd", buttons = "yes"), "single TRUE or FALSE")
  expect_error(
    fgcz_render("x.qmd", buttons = c(TRUE, FALSE)),
    "single TRUE or FALSE"
  )
  expect_error(fgcz_render("x.qmd", buttons = NA), "single TRUE or FALSE")
})

test_that("plot finder downloads use report metadata and current timestamps", {
  toolbar <- paste(
    readLines(fgcz_quarto_dir("fgcz-plot-finder.html"), warn = FALSE),
    collapse = "\n"
  )

  expect_match(toolbar, "right: 0; top: 25vh", fixed = TRUE)
  expect_match(toolbar, "flex-direction: column", fixed = TRUE)
  expect_match(toolbar, '<span class="lbl">Download</span>', fixed = TRUE)
  expect_match(toolbar, "fgcz-report-metadata", fixed = TRUE)
  expect_match(toolbar, "'order_' + orderId", fixed = TRUE)
  expect_match(toolbar, "'workunit_' + workunitId", fixed = TRUE)
  expect_match(toolbar, "timestampForFilename(new Date())", fixed = TRUE)
  expect_match(toolbar, "zipDosDateTime", fixed = TRUE)
  expect_match(toolbar, "u16(stamp.time), u16(stamp.date)", fixed = TRUE)
})
