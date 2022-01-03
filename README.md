
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Calculating Residential Segregation Scores

The purpose of this repository is to provide a simple and reproducible
[R](https://www.r-project.org/) pipeline to investigate residential
segregation using US census data. The pipeline contains two components:

1.  pulling decennial US census data of Year 2000, 2010, 2020 via R
    package [tidycensus](https://walker-data.com/tidycensus/index.html)
2.  calculating three residential segregation indices, including
    dissimilarity, isolation and interaction indices, at the preferred
    geographical level, e.g. county or census tract level

We hope this work would relieve social scientists from repetitive data
pulling, and inspire to adapt the reproducible pipeline.

> If you don’t have time to go through the whole documentation, please
> finish reading the [Remarks](#remarks) Section

## Get Started

1.  Download [R](https://www.r-project.org/) and [RStudio
    IDE](https://www.rstudio.com/products/rstudio/download/)
2.  Install the necessary workflow packages
    [`targets`](https://cran.r-project.org/web/packages/targets/index.html)
    and [`renv`](https://rstudio.github.io/renv/articles/renv.html) if
    you don’t already have
3.  Open the R project in RStudio and call `renv::restore()` to install
    the required R packages. Please give permission to install the
    necessary packages. This will mirror the version of packages used in
    the creation of the work exactly.
4.  Acquire your census api key string via
    <https://api.census.gov/data/key_signup.html>, and replace in the
    `_targets.R` file
5.  Modify the code to reflect your research needs. We highlight the
    places that requires customizationthe tag `TODO:`, which can be
    enlisted via [global
    search](https://support.rstudio.com/hc/en-us/articles/200710523-Navigating-Code),
    i.e. `cmd/control + shift + f`.

-   Change year, states, and geographic levels that your indices depends
    on
-   Confirm if the variable codes in census data bases match with your
    prefered variables, e.g. total, total number of Majority, and total
    number of Minority. The variable code could be different depending
    on the year you use. For example: “P003003” means *Total!!Population
    of one race!!White alone* in [2000
    data](https://api.census.gov/data/2000/dec/sf1/variables.html), and
    means *Total!!Black or African American* alone [2010
    data](https://api.census.gov/data/2010/dec/sf1/variables.html)

5.  call the `targets::tar_make()` function to run the pipeline.

## Examples

\[TODO: Add Alabama Map\]

## Remarks

1.  When no majority, don’t know how to calculate dissimilarity, and
    interaction score should be default to 0, and isolation score should
    be 1 if there is no other minority. In our case, we default them
    to 0.

2.  It is very important to confirm your variable code. Even though we
    build error prevention mechanism in the code. However, that doesn’t
    eliminate all the errors.

3.  Meanwhile, when we categorize people, we only considered the people
    who reported one race, while it seems possible to report more than 1
    race, e.g. P003008, Total!!Two or More Races in [2010 census
    data](https://api.census.gov/data/2010/dec/sf1/variables.html)

4.  When reporting the rs scores, we report up to 3 decimal places.
    However, this can be modified by go to xxx. <!-- badges: start -->
    <!-- badges: end -->

## Replated Resources

## Ackowledgement

#### References
