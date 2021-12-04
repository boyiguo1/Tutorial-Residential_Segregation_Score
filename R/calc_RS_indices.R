
calc_RS_indices <- function(top_dat, btm_dat){

  top_geo_length <- top_dat$geoid %>% str_length() %>% unique()
  
  btm_dat %<>%
    mutate(top_geoid = str_sub(geoid, start = 1, end = top_geo_length)) %>% 
    select(-c(geoid, name))

  if(any(top_dat$n_black==0))
    warning("Geographic area with no minority exists, and marked with missing(`NA`) scores.")
  
  if(any(top_dat$n_white==0))
    warning("Geographic area with no majority exists, and marked with missing(`NA`) scores.")
    
  browser()
  # ful_dat <- 
  full_join(
    x = top_dat %>% select(-name),
    y = btm_dat,
    by = c("geoid" = "top_geoid"),
    suffix=c("_top", "_btm")
  ) %>% 
    filter(
      n_black_top != 0,
      n_white_top != 0
      ) %>% 
    # Calculate lower level stats
    mutate( 
      d_wb = n_total_btm * abs(p_black_btm - p_black_top)/(2*n_total_top*p_black_top*(1-p_black_top)),
      
      # another way of calculating dissimilarity measure
      # d_wb2 = .5*abs(white/cnty_white - black/cnty_black),
      
      # Interaction index  for blacks (minority population) and white (majority population)
      int_wb = (n_black_btm/n_black_top)*(n_white_btm/n_total_btm), 
      iso_b = (n_black_btm/n_black_top)*(n_black_btm/n_total_btm) 
    ) 

  # TODO(boyiguo1): needs to verify if thestat is correct now.  
  
  
  # TODO(boyiguo1): merge back to the top level data, and set no minority/majority data to NAs
  
  # %>% 
  #   group_by(geo_id) %>% 
  #   summarize(
  #     dissimilarity = sum(d_wb, na.rm = T),
  #     interaction = sum(int_wb, na.rm = T),
  #     isolation = sum(iso_b, na.rm = T),
  #     .groups = "drop") %>% 
  #   mutate(fips = paste0(state, county))
  # 
  # return(merged_dat)
}