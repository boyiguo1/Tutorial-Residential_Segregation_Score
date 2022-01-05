
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Calculating Residential Segregation Indices

The purpose of this repository is to provide a simple and reproducible
[R](https://www.r-project.org/) pipeline to investigate residential
segregation (RS) using US census data. The pipeline contains two
components:

1.  pulling decennial US census data of Year 2000, 2010, 2020 via R
    package [tidycensus](https://walker-data.com/tidycensus/index.html)
2.  calculating three residential segregation indices, including
    dissimilarity, isolation and interaction indices, at the preferred
    geographical level, e.g. county or census tract level

We hope this work would relieve social scientists from repetitive data
pulling, and inspire to adapt the reproducible pipeline.

> Note: If you don’t have the time to go through the whole
> documentation, please finish reading the [Remarks](#remarks) Section
> before modifying the code

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
    <https://api.census.gov/data/key_signup.html>, and replace at the
    beginning of the `_targets.R` file
5.  Modify the code to reflect your research needs. We highlight the
    places that requires customization with the tag `TODO:`, which can
    be enlisted via a [global
    search](https://support.rstudio.com/hc/en-us/articles/200710523-Navigating-Code),
    i.e. `cmd/control + shift + f`.
    -   Change year, states, and geographic levels, where the upper
        level is your preferred level and the lower level is the level
        constituent the upper level. For example, in order to calculate
        county level indices (upper level), we need to have census tract
        level statistics (lower level).
    -   **Confirm if the variable codes in census databases match with
        your preferred variables.** The variable code is year-specific,
        i.e. could be different depending on the year you use. For
        example, the same variable code `P003003` means
        `Total!!Population of one race!!White alone` in [2000
        data](https://api.census.gov/data/2000/dec/sf1/variables.html),
        and means `Total!!Black or African American alone` [2010
        data](https://api.census.gov/data/2010/dec/sf1/variables.html)
6.  call `targets::tar_make()` in the console to run the pipeline.

## Examples

In this section, we provide two examples for calculating RS indices of
*one state* (stored in [`master`
branch](https://github.com/boyiguo1/Tutorial-Residential_Segregation_Score/tree/master))
or *multiple states* (stored in [`meds_desert`
branch](https://github.com/boyiguo1/Tutorial-Residential_Segregation_Score/tree/meds_desert))
respectively.

### One State Example: *2010 Alabama Dissimilarity Index at County Level*

In this example, we provide the pipeline to calculate the indices for a
single state. As an bonus, a section of code that plots a index to the
map are supplied, as shown in *Figure 1*. [1]. the Alabama County Level
using 2010 US census data, deposited in the
[`master`](https://github.com/boyiguo1/Tutorial-Residential_Segregation_Score/tree/master)
branch of this repository. The example also include the code to plot the
county-level dissimilarity index on the Alabama map. As an demonstration
of how easy the pipeline can be produce customized indices, we present
*Figure 1* which contains the county-level dissimilarity score
calculated with census tract level statistics and block level
statistics.

| ![](README_files/figure/2010_AL_Disml_tract.png) | ![](README_files/figure/2010_AL_Disml_block.png) |
|--------------------------------------------------|--------------------------------------------------|

**Figure 1**: 2010 Alabama Dissimilarity Index at county level
calculated with census tract level statistics *(a)* and block level
statistics *(b)*

### Multiple States Example: *2010 RS Indices of Medication Desert at Census Tract Level*

The example demonstrate how to calculate

## Remarks

### Numeric Calculation

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

4.  Error prevention is implemented in. It is not guaranteed to caught
    all errors

5.  When reporting the rs scores, we report up to 3 decimal places.
    However, this can be modified by go to xxx.

### Interpretation

1.  What it is designed for originally. How it would be interpreted when
    using nationally

2.  When calculating the indices at a geogrphic level, it is possible to
    define the lower level that constutes the upper level differently,
    as we have seen in the Alabama example. How much it changes.

3.  what would be the rs score interpreted when few self-defined
    majority and minority located. e.g. When calculating the indices of
    White (majority) compared to Black (minority) in a Indian
    conservatory, neither is majority and minority in that sense. How to
    defined.

### Practice

1.  Sending requests, FIPS, leading zero, Excel automatically omitting
    leading zeros. enclose the FIPS with quoationa marks

2.  For ease of collaborators, it is better to generate the geoid when
    pulling data, instead of giving individual FIPS for different
    levels. It is not a big deal, but potentially create human error
    when concatenating the FIPS. for example leading zero problem

3.  Carefully choose which level of fips you want to have. potentially
    leading to selection bias, where severity is unknown.

<!-- badges: start -->
<!-- badges: end -->

#### References

[1] Only produce one of the graph, where the caption needs to be revised
