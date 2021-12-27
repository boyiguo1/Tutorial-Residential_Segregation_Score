## TODO: replace the data cleaning procedure with your own

clean_up_geo <- function(dat){
  dat %>% 
    mutate(
      # Adding leading zeros
      state_fip = sprintf("%02d", statefp),
      county_fip = sprintf("%03d", countyfp),
      tract_fip = sprintf("%06d", tractfp),
      # Create geoid
      geoid = paste0(state_fip, county_fip, tract_fip)
    )
}
