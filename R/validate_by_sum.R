validate_by_sum <- function(top_dat, btm_dat){
  
  top_geo_length <- top_dat$geoid %>% str_length() %>% unique()
  
  # error prevention
  if(length(top_geo_length) != 1)
    stop("Unequal GEOID length in top_dat. Check data pull!")
  
  btm_dat %<>%
    mutate(top_geoid = str_sub(geoid, start = 1, end = top_geo_length)) %>% 
    group_by(top_geoid) %>% 
    summarise(across(starts_with("n_"), sum))
  
  ful_dat <- full_join(
    x = top_dat %>% select(geoid, starts_with("n_")),
    y = btm_dat,
    by = c("geoid" = "top_geoid")
  )
  
  if(any(is.na(ful_dat)))
    stop("Empty entry when merging top_dat and btm_dat. Check data pull!")

  if(with(ful_dat, 
          n_total.x != n_total.y ||
          n_majority.x != n_majority.y ||
          n_minority.x != n_minority.y))
    stop("Bottom level doesn't sum up to top level population size. Check data pull!")
 
  return(NULL) 
}
