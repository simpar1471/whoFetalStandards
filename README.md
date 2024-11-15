
<!-- README.md is generated from README.Rmd. Please edit that file -->

# whoFetalStandards

<!-- badges: start -->
<!-- badges: end -->

**whoFetalStandards** makes the WHO Fetal Standards available to R
users. It has few functions, which can be used to convert fetal biometry
to centiles or z-scores. The API is very similar to the **gigs** package
for R, which implements similar standards from the WHO and the
INTERGROWTH-21<sup>st</sup> projects. You can find that package
[here]().

## Installation

You can install the development version of whoFetalStandards like so:

``` r
pak::pkg_install("simpar1471/whoFetalStandards")
```

## Available standards

The WHO published six Fetal standards. All of them are sex-agnostic
except for estimated fetal weight, which is different for males and
females.

| Acronym  | Description                    | Unit |
|----------|--------------------------------|------|
| `acfga`  | abdominal circumference-for-GA | m    |
| `bpdfga` | biparietal diameter-for-GA     | mm   |
| `efwfga` | estimated fetal weight-for-GA  | g    |
| `flfga`  | femur length-for-GA            | mm   |
| `hcfga`  | head circumference-for-GA      | mm   |
| `flfga`  | femur length-for-GA            | mm   |

## Examples

### Conversion functions

Convert fetal biometry to centiles/z-scores with `value2zscore()` and
`value2centile()`. These should be used for measurements taken from 98
to 280 days (14 to 40 weeks).

``` r
library(whoFetalStandards)

# Convert biparietal diameter values to centiles
value2centile(81, gest_days = 30 * 7, acronym = "bpdfga")
#> [1] 0.9000039

# Convert biparietal diameter values to centiles
value2zscore(81, gest_days = 30 * 7, acronym = "bpdfga")
#> [1] 1.281574
```

### Hadlock fetal weight estimation

The package also includes a simple function for estimating fetal weight
in g, using Hadlock’s three-parameter equation.

``` r
hadlock_efw(headcirc_cm = 12, 
            abdocirc_cm = 9.5, 
            femurlen_cm = 10)
#> [1] 1382.929
```
