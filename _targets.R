library(targets)

# This is an example _targets.R file. Every
# {targets} pipeline needs one.
# Use tar_script() to create _targets.R and tar_edit()
# to open it again for editing.
# Then, run tar_make() to run the pipeline
# and tar_read(summary) to view the results.

# Define custom functions and other global objects.
# This is where you write source(\"R/functions.R\")
# if you keep your functions in external scripts.
# lapply

# Set target-specific options such as packages.
tar_option_set(packages = c("tidyverse", "tidycensus"))

# Set up census api key
## TODO: Replace Sys.getenv("CENSUS_API_KEY) with your census api key string.
##       Census api key can be requested via https://api.census.gov/data/key_signup.html
tidycensus::census_api_key(Sys.getenv("CENSUS_API_KEY"))

# End this file with a list of target objects.
list(
  tar_target(year, 2010),
  tar_target(state, "AL"),
  tar_target(level, "state"),
  tar_target(lower_lvl_stat,
             get_decennial(geography=level,
                           variables =  c("P013001",    # Total
                                          "P013002",    # Total White
                                          "P013003"     # Total Black
                                          ) ,
                           year = year)) # Call your custom functions as needed.
)
