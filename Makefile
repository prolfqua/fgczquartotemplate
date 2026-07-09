.DEFAULT_GOAL := check

PKG_NAME := $(shell awk '/^Package:/ {print $$2; exit}' DESCRIPTION)

.PHONY: help document sync test check install site format clean

help:
	@echo "$(PKG_NAME) targets:"
	@echo "  make document  - regenerate roxygen2 docs (man/, NAMESPACE)"
	@echo "  make sync      - mirror _extensions/ into vignettes/_extensions/ for the demo vignette"
	@echo "  make test      - run testthat tests"
	@echo "  make check     - document + sync, then full R CMD check"
	@echo "  make install   - document + sync, then install into the active R library"
	@echo "  make site      - install, then build the documentation site locally with altdoc"
	@echo "  make format    - format R sources with air"
	@echo "  make clean     - remove build artifacts"

document:
	Rscript -e "devtools::document()"

# The single source is _extensions/fgczquartotemplate/ (what `quarto add` fetches).
# sync mirrors it into the demo vignette's vignettes/_extensions/ so both build
# against byte-identical files; CI fails if the mirror is out of date.
sync:
	Rscript -e 'src <- "_extensions/fgczquartotemplate"; dst <- "vignettes/_extensions/fgczquartotemplate"; dir.create(dst, recursive = TRUE, showWarnings = FALSE); ok <- file.copy(list.files(src, full.names = TRUE), dst, overwrite = TRUE); if (!all(ok)) stop("sync failed")'

test: document
	Rscript -e "devtools::test()"

check: document sync
	Rscript -e "devtools::check()"

install: document sync
	R CMD INSTALL .

# altdoc renders the vignettes (including the tabset example report) natively via
# Quarto, so panel-tabsets are preserved — unlike pkgdown, which mangles them.
site: install
	Rscript -e "altdoc::render_docs(freeze = FALSE)"

format:
	air format .

clean:
	rm -rf *.Rcheck docs _quarto
	rm -f Rplots.pdf
	rm -f ../$(PKG_NAME)_*.tar.gz
