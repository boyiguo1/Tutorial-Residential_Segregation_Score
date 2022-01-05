library(targets)
library(tarchetypes)

# Set target-specific options such as packages.
tar_option_set(packages = c("tidyverse", "tidycensus",
                            "glue"))

# Load helper funcitons
lapply(list.files("./R", full.names = TRUE, recursive = TRUE), source)

# Set up census api key
## TODO: Replace Sys.getenv("CENSUS_API_KEY) with your census api key string.
##       Census api key can be requested via https://api.census.gov/data/key_signup.html
tidycensus::census_api_key(Sys.getenv("CENSUS_API_KEY"))

tar_plan(
  # Optional: Calculate the RS for specific region
  tar_file(geo_id_file,
           "data/pharm_desert_2015.xls"),
  tar_target(geoid_raw,
             readxl::read_xls(path = geo_id_file)),
  tar_target(geoid_dat,
             clean_up_geo(geoid_raw)),
  
  # Configuration -----------------------------------------------------------
  ## TODO: Configure your calculation by replacing the following section
  tar_target(year, 2010),
  # In this analysis, we limits to certain required states
  tar_target(states, 
             geoid_dat %>% pull(statefp) %>% unique()),
  # Alternatively, you can supply a vector  of state names
  # tar_target(states, c("Arizona", "Utah"))
  tar_target(top_lvl, "tract"),
  tar_target(btm_lvl, "block"),
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
               year = year, state = states) %>% 
               prep_tidycensus_data(),
             pattern = map(states)),
  
  
  tar_target(btm_dat,
             get_decennial(
               geography=btm_lvl,
               variables =  c(
                 n_total = census_code_total,    
                 n_majority = census_code_maj,    
                 n_minority = census_code_min    
               ) ,
               year = year, state = states) %>% 
               prep_tidycensus_data(),
             pattern = map(states)),
  
  # Validate the sum of the btm lvl stats is the top lvl stats
  tar_target(validate_data_pull,
             validate_by_sum(top_dat, btm_dat),
             pattern = map(top_dat, btm_dat)
  ),
  
  
  # Calculate RS Indices ----------------------------------------------------
  # Calculate residential segregation  measures
  tar_target(rs_indices,
             calc_RS_indices(top_dat, btm_dat),
             pattern = map(top_dat, btm_dat)
  ),
  
  
  # Optional: merge residential segregation to the original data
  tar_target(merged_dat,
             left_join(
               x = geoid_dat, y = rs_indices,
               by = "geoid"
             )
  ),
  
  
  # Data Saving -------------------------------------------------------------
  # Optional: Save data to csv and rds format
  tar_target(save_csv_file,
             write_csv(merged_dat, 
                       "data/pharm_desert_rs_scores_2010_census_data.csv",
                       quote = "all" # to prevent deleting leading zero of FIPs
             )
  ),
  
  tar_target(save_rds_file,
             saveRDS(merged_dat, 
                     "data/pharm_desert_rs_scores_2010_census_data.rds")
  )
  
)
