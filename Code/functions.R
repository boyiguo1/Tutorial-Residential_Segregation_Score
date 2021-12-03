# Custom functions are an important part of a drake workflow.
# This is where you write them.
# Details: https://books.ropensci.org/drake/plans.html#functions

calc_RS_indices <- function(tract_dat, county_dat){
  
  # Mergin tract and county stats by state and county code
  merged_dat <- left_join(
    tract_dat,
    county_dat,
    by = c("state", "county"),
    suffix=c("_tract", "_county")
  ) %>% 
    # Calculate tract level indices
    mutate( 
      d_wb = total_tract *abs(prop_b_tract - prop_b_county)/(2*total_county*prop_b_county*(1-prop_b_county)),
      
      # another way of calculating dissimilarity measure
      # d_wb2 = .5*abs(white/cnty_white - black/cnty_black),
      
      # Interaction index  for blacks (minority population) and white (majority population)
      int_wb = black_tract/black_county * white_tract/total_tract, 
      iso_b = (black_tract/black_county * black_tract/total_tract)  
    ) %>% 
    group_by(state, county) %>% 
    summarize(
      dissimilarity_wb = sum(d_wb, na.rm = T),
      interaction_wb = sum(int_wb, na.rm = T),
      isolation_b = sum(iso_b, na.rm = T),
      .groups = "drop") %>% 
     mutate(fips = paste0(state, county))
  
  return(merged_dat)
}