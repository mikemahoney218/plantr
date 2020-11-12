
<!-- README.md is generated from README.Rmd. Please edit that file -->

# plantr

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R-CMD-check](https://github.com/mikemahoney218/plantr/workflows/R-CMD-check/badge.svg)](https://github.com/mikemahoney218/plantr/actions)
<!-- badges: end -->

The goal of plantr is to provide a simple R wrapper around the [USDA
PLANTS Database](https://plants.sc.egov.usda.gov/java/citePlants) API,
allowing users to easily download data on plant species as a part of
their regular workflow.

## Installation

You can install the development version of plantr with:

``` r
remotes::install_github("mikemahoney218/plantr")
```

## Usage

`plantr` is a little seedling of a package at the moment, without much
in the way of higher-order functions. With that said, the main workhorse
of the package is already implemented as `ptr_search`, letting you
search the PLANTS Database directly from R. Searching the basic API
(which returns data on plant names and USDA symbols) is as simple as:

``` r
library(plantr)

ptr_search(common_name = "balsam fir")
#>   synonym_plants accepted_plant.symbol   accepted_plant.scientific_name
#> 1           NULL                 ABBAP Abies balsamea var. phanerolepis
#> 2           NULL                 ABBAB     Abies balsamea var. balsamea
#> 3           NULL                  ABBA                   Abies balsamea
#>   accepted_plant.common_name
#> 1                 balsam fir
#> 2                 balsam fir
#> 3                 balsam fir
```

The full API may also be searched by setting `basic` to `FALSE`. Note
that this example uses a single USDA plant symbol in order to speed up
processing time:

``` r
ptr_search(symbol = "ABBAB", basic = FALSE)
#>                synonyms accepted.symbol
#> 1 PIBA3, Pinus balsamea           ABBAB
#>                                             accepted.nativity
#> 1 Canada, Lower 48 States, Saint Pierre and Miquelon, N, N, N
#>       accepted.scientific_name accepted.state_noxious_status
#> 1 Abies balsamea var. balsamea                          NULL
#>   accepted.federal_noxious_status accepted.plants_invasive_status
#> 1                            NULL                            NULL
#>   accepted.state_te_status accepted.federal_te_status
#> 1                     NULL                       NULL
#>   accepted.regional_wetland_indicator_status accepted.common_name
#> 1                                       NULL           balsam fir
#>   accepted.growth_habits accepted.durations accepted.classification.kingdom
#> 1               Tree, TR      Perennial, PR                         Plantae
#>   accepted.classification.subkingdom accepted.classification.superdivision
#> 1                      Tracheobionta                         Spermatophyta
#>   accepted.classification.division accepted.classification.subclass
#> 1                    Coniferophyta                               NA
#>   accepted.classification.order accepted.classification.genus
#> 1                       Pinales                         Abies
#>   accepted.classification.species accepted.classification.variety
#> 1                        balsamea                        balsamea
#>   accepted.classification.plant_class
#> 1                           Pinopsida
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          accepted.distribution.states
#> 1 01, 03, 04, 24, NF, 10, 33, 39, 50, 27, 09, 55, 18, 51, 23, 54, 26, 25, 08, 09, 19, 44, 36, 11, 07, LB, 42, 005, 061, 031, 001, 135, 071, 021, 115, 003, 111, 041, 087, 045, 017, 059, 029, 077, 163, 057, 169, 075, 007, 035, 065, 137, Becker, Itasca, Cook, Aitkin, Roseau, Koochiching, Cass, Pine, Anoka, Otter Tail, Douglas, Mahnomen, Fillmore, Carlton, Isanti, Clearwater, Lake of the Woods, Washington, Hubbard, Winona, Lake, Beltrami, Crow Wing, Kanabec, St. Louis, 035, 075, 115, 051, 123, 013, 125, 017, 019, 061, 073, 107, 031, 078, 131, 003, 091, 005, 021, 007, 099, 029, 071, 037, 001, 009, 069, 129, 113, 083, 121, 097, 141, 117, 085, 067, 109, 033, 119, 135, 041, Eau Claire, Marinette, Shawano, Iron, Vernon, Burnett, Vilas, Chippewa, Clark, Kewaunee, Marathon, Rusk, Douglas, Menominee, Washington, Ashland, Pepin, Barron, Columbia, Bayfield, Price, Door, Manitowoc, Florence, Adams, Brown, Lincoln, Washburn, Sawyer, Oconto, Trempealeau, Portage, Wood, Sheboygan, Oneida, Langlade, St. Croix, Dunn, Taylor, Waupaca, Forest, 047, 069, 065, 109, 029, 063, 011, 143, 073, 089, 019, 153, 137, 071, 031, 041, 033, 097, 003, 131, 039, 103, 055, 051, 053, 043, 013, 129, 135, 083, 001, 035, 095, 133, 007, 061, 119, 105, Emmet, Iosco, Ingham, Menominee, Charlevoix, Huron, Arenac, Roscommon, Isabella, Leelanau, Benzie, Schoolcraft, Otsego, Iron, Cheboygan, Delta, Chippewa, Mackinac, Alger, Ontonagon, Crawford, Marquette, Grand Traverse, Gladwin, Gogebic, Dickinson, Baraga, Ogemaw, Oscoda, Keweenaw, Alcona, Clare, Luce, Osceola, Alpena, Houghton, Montmorency, Mason, 027, 001, 015, 017, 011, 003, Worcester, Barnstable, Hampshire, Middlesex, Franklin, Berkshire, 003, 009, 013, 011, 005, Hartford, New Haven, Tolland, New London, Litchfield, 007, Providence, 049, 123, 115, 083, 031, 089, 077, 067, 025, 019, 033, 043, 013, 109, 065, 041, 015, 009, 121, 101, 095, 045, 053, 081, 029, 111, 105, 039, Lewis, Yates, Washington, Rensselaer, Essex, St. Lawrence, Otsego, Onondaga, Delaware, Clinton, Franklin, Herkimer, Chautauqua, Tompkins, Oneida, Hamilton, Chemung, Cattaraugus, Wyoming, Steuben, Schoharie, Jefferson, Madison, Queens, Erie, Ulster, Sullivan, Greene, 117, 069, 081, 105, 123, 027, 089, 115, 107, 113, 061, 127, 035, 131, 103, Tioga, Lackawanna, Lycoming, Potter, Warren, Centre, Monroe, Susquehanna, Schuylkill, Sullivan, Huntingdon, Wayne, Clinton, Wyoming, Pike
```

Please note that `plantr` is still in an experimental phase, and
breaking changes may happen to any function as development continues.
