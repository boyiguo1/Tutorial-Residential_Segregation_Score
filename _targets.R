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
  
  # Configuration -----------------------------------------------------------
  ## TODO: Configure your calculation by replacing the following section
  tar_target(year, 2010),
  tar_target(state, "AL"),
  tar_target(top_lvl, "county"),
  tar_target(btm_lvl, "tract"),
  tar_target(census_code_total, "P003001"), # 2010 Total
  tar_target(census_code_maj,   "P003002"), # 2010 Total White (Majority)
  tar_target(census_code_min,   "P003003"), # 2010 Total Black (Minority)
  
  
  # Census Data Pull --------------------------------------------------------
  # Pull census data following the year, state and levels
  # TODO: Check if the code names "P003001/2/3" are for population size for your year
  tar_target(top_dat,
             get_decennial(
               geography=top_lvl,
               variables =  c(
                 n_total = census_code_total,    
                 n_majority = census_code_maj,    
                 n_minority = census_code_min    
               ),
               year = year, state = state) %>% 
               prep_tidycensus_data()),
  
  tar_target(btm_dat,
             get_decennial(
               geography=btm_lvl,
               variables =  c(
                 n_total = census_code_total,    
                 n_majority = census_code_maj,    
                 n_minority = census_code_min   
               ),
               year = year, state = state)%>% 
               prep_tidycensus_data()),
  
  # Validate the sum of the btm lvl stats is the top lvl stats
  tar_target(validate_data_pull,
             validate_by_sum(top_dat, btm_dat)
  ),
  
  
  # RS Calculation ----------------------------------------------------------
  # Calculate residential segregation  measures
  tar_target(rs_indices,
             calc_RS_indices(top_dat, btm_dat)
  ),
  
  
  # Create Map --------------------------------------------------------------
  # Plot on a map
  tar_target(top_geo_dat,
             get_decennial(
               geography=top_lvl,
               variables =  c(
                 n_total = census_code_total,    
                 n_majority = census_code_maj,    
                 n_minority = census_code_min   
               ),
               year = year, state = state,
               geometry = TRUE) %>% 
               rename_all(tolower)
  ),
  
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
      scale_fill_viridis_c(
        name = "Dissimilarity",
        option = "magma",
        limits = c(0,1)
      ) +
      theme_minimal() +
      labs(caption = paste0(year, " ", state, " Residential Segregation Index (Dissimilarity) at ",
                            top_lvl," level.\n", "Transparent areas mean missing scores"))
    
  )
  
)
