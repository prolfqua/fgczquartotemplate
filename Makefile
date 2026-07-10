.DEFAULT_GOAL := check

PKG_NAME := $(shell awk '/^Package:/ {print $$2; exit}' DESCRIPTION)

.PHONY: help document sync test check install site format clean

help:
	@echo "$(PKG_NAME) targets:"
	@echo "  make document  - regenerate roxygen2 docs (man/, NAMESPACE)"
	@echo "  make sync      - mirror inst/quarto assets into _extensions/ and vignettes/_extensions/, verify _metadata.yml <-> _extension.yml agree"
	@echo "  make test      - run testthat tests"
	@echo "  make check     - document + sync, then full R CMD check"
	@echo "  make install   - document + sync, then install into the active R library"
	@echo "  make site      - install, then build the documentation site locally with altdoc"
	@echo "  make format    - format R sources with air"
	@echo "  make clean     - remove build artifacts"

document:
	Rscript -e "devtools::document()"

# The single source of truth is inst/quarto/. sync mirrors the shared assets into
# the Quarto extension (_extensions/) and the demo vignette (vignettes/_extensions/)
# and fails on any drift, so everything that ships or renders the extension depends on it.
sync:
	Rscript data-raw/sync_assets.R

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
