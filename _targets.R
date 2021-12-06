library(targets)
library(tarchetypes)

# Set target-specific options such as packages.
tar_option_set(packages = c("tidyverse", "tidycensus"))

# Load helper funcitons
lapply(list.files("./R", full.names = TRUE, recursive = TRUE), source)

# Set up census api key
## TODO: Replace Sys.getenv("CENSUS_API_KEY) with your census api key string.
##       Census api key can be requested via https://api.census.gov/data/key_signup.html
tidycensus::census_api_key(Sys.getenv("CENSUS_API_KEY"))

tar_plan(
  ## TODO: Configure your calculation by replacing the following section
  tar_target(year, 2010),
  tar_target(state, "AL"),
  tar_target(top_lvl, "tract"),
  tar_target(btm_lvl, "block"),
  
  # Pull census data following the year, state and levels
  # TODO: Check if the code names "P003001/2/3" are for population size for your year
  tar_target(top_dat,
             get_decennial(
               geography=top_lvl,
               variables =  c("P003001",    # Total
                              "P003002",    # Total White
                              "P003003"     # Total Black
               ),
               year = year, state = state) %>% 
               prep_tidycensus_data()),
  
  tar_target(btm_dat,
             get_decennial(
               geography=btm_lvl,
               variables =  c("P003001",    # Total
                              "P003002",    # Total White
                              "P003003"     # Total Black
               ) ,
               year = year, state = state)%>% 
               prep_tidycensus_data()),
  
  # Validate the sum of the btm lvl stats is the top lvl stats
  tar_target(validate_data_pull,
             validate_by_sum(top_dat, btm_dat)
  ),
  
  
  # Calculate residential segregation  measures
  tar_target(rs_indices,
             calc_RS_indices(top_dat, btm_dat)
  ),
  
  
  # Plot on a map
  # TODO(boyiguo1): pull up the gis info for top lvl
  tar_target(top_geo_dat,
             get_decennial(
               geography=top_lvl,
               variables = c(
                 "P003001",    # Total
                 "P003002",    # Total White
                 "P003003" ),
               year = year, state = state,
               geometry = TRUE) %>% 
               rename_all(tolower)
  ),
  
  # TODO(boyiguo1): use map to create a list of geom_map for every measures.
  # TODO(boyiguo1): joint the maps
  
  tar_target(
    rs_map,
    top_geo_dat %>% group_by(geoid) %>% slice(1) %>% 
      select(-c(variable, value)) %>% 
      ungroup() %>% 
      full_join(
        rs_indices
      ) %>% 
      ggplot(aes(fill = rs_dissimilarity)) +
      geom_sf(color = NA) + 
      scale_fill_viridis_c(option = "magma")
    
    # TODO(boyiguo1): add table caption for which area this , and level it is.
    # e.g. (Tract level residential segregation score of State)
    
    # TODO(boyiguo1): add notion, grey is missing (i.e. no minority/majority population in the area)
    # TODO(boyoiguo1): add explaining the scale
  )
  
)
