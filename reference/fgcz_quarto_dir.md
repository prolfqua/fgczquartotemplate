# Path to the installed Quarto assets

Path to the installed Quarto assets

## Usage

``` r
fgcz_quarto_dir(...)
```

## Arguments

- ...:

  Character path components appended to the asset directory, e.g.
  `fgcz_quarto_dir("template.qmd")`.

## Value

An absolute path to the package's `inst/quarto` directory (or a file
within it).

## Examples

``` r
fgcz_quarto_dir()
#> [1] "/tmp/RtmpSx3vVh/temp_libpath1a3a15be5f0c/fgczquartotemplate/quarto"
fgcz_quarto_dir("template.qmd")
#> [1] "/tmp/RtmpSx3vVh/temp_libpath1a3a15be5f0c/fgczquartotemplate/quarto/template.qmd"
```
