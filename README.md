# areal-comparison

Code for the manuscript Howes *et al.* "Comparing models for spatial structure in small-area estimation" (in preparation).

Small-area estimation models typically use the Besag model, a type of Gaussian Markov random field, to model spatial structure.
However, for irregular geometries, the assumptions made by the Besag model do not seem plausible (in the image below, geometric irregularity is increasing from left to right).
The goal of this work is to determine whether or not, in practice, this matters.

![](simulation-geometries.png)

## R package dependencies

This repository is supported by the [`bsae`](https://github.com/athowes/bsae) package, which can be installed from Github via:

```r
devtools::install_github("athowes/bsae")
```

Additionally, the `R-INLA` package is not currently available on CRAN, and instead may be installed by following [instructions](https://www.r-inla.org/download-install) from the project website.

## File structure

The directories of this repository are:

| Directory   | Contains |
|-------------|--------------|
| `make`      | Scripts used to run the reports. `_make.R` runs everything in order. |
| `misc`      | Miscellaneous code, not used as part of `orderly`. |
| `src`       | All `orderly` reports. |
| `utils`     | Helper scripts for common development tasks. |

## `orderly`

We use the [`orderly`](https://github.com/vimc/orderly) package ([RESIDE, 2020](https://reside-ic.github.io/)) to simplify the process of doing reproducible research.
After installing [`orderly`](https://github.com/vimc/orderly) (from either CRAN or Github) a report, let's say called `example`, may be run by:

```r
orderly::orderly_run(name = "src/example")
```

The results of this run will appear in the `draft/` folder (ignored on Github).
To commit the draft (with associated `id`) to the `archive/` folder (also ignored on Github, and which should be treated as "read only") use:

```r
orderly::orderly_commit(id)
```

Any outputs of this report will then be available to use as dependencies within other reports.
