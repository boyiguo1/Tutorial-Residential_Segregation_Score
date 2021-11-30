pull_2000_census_tract_data <- function() {
  
  # Finding all states
  ## Alaska and Hawaii are left out
  state_vec <- c(
    gsub(" ", "_", state.name %>% tolower()),
    "district_of_columbia"
  ) %>%
    setdiff(c("alaska", "hawaii"))
  
  # Retrieve the census tract data from each required states
  tract_dat <- lapply(state_vec, function(stt) {
    
    parse(text = paste0("data(", stt, ".tract",")")) %>% eval
    state.tract <- paste0(stt,".tract") %>% get
    
    
    state.tract.dat<- state.tract@data %>%  
      mutate(
        tract = case_when(
          str_length(tract)==4 ~ str_c(tract,"00"),
          str_length(tract)==6 ~ as.character(tract),
          TRUE ~NA_character_
          ),
        fips = paste0(state, county, tract),
        # 2000
        total = pop2000,
        other = select(., ameri.es, asian, hawn.pi, other, mult.race) %>% rowSums(.)
      ) %>%
      # 2010
      # other = select(., ameri.es, asian, hawn.pi, other, mult.race) %>% rowSums(.)) %>%
      select(state, county, tract, fips, total, white, black, other) %>% 
      mutate(prop_w = white/total,
             prop_b = black/total) %>%
      arrange(fips)
    
    return(state.tract.dat)
  })
  
  # Binding the lists together
  ret <- do.call(rbind, tract_dat)
  
  return(ret)
}