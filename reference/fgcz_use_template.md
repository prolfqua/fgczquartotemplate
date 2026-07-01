# Copy the starter template into a directory

Copies `template.qmd` (a generic FGCZ report skeleton) into `dir`,
together with the styling assets it needs. Use this to bootstrap a new
report.

## Usage

``` r
fgcz_use_template(dir, to = "template.qmd", overwrite = FALSE)
```

## Arguments

- dir:

  Destination directory. Created if it does not exist.

- to:

  Filename for the copied template within `dir`.

- overwrite:

  Overwrite an existing file of the same name.

## Value

Path to the copied template, invisibly.

## Examples

``` r
if (FALSE) { # \dontrun{
fgcz_use_template("my_report", to = "my_report.qmd")
} # }
```
