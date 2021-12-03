prep_tidycensus_data <- function(raw_dat){
  
  # Rename the variables from code name
  ret <- raw_dat %>%
    mutate(
      new_var = case_when(
        variable == "P003001" ~ "n_total",
        variable == "P003002" ~ "n_white",
        variable == "P003003" ~ "n_black",
        TRUE ~ NA_character_
      )
    ) %>% 
    rename_all(tolower) %>% 
    select(-variable)
  
  # Error prevention
  if(any(is.na(ret$new_var)))
    stop("Unknown code name exists")
  
  # browser()
  # Convert from long table to wide table
  ret %<>%
    pivot_wider(names_from = new_var,
                values_from = value) %>% 
    filter(n_total != 0)
  
  # Error Prevention
  if(any(ret$n_total < ret$n_white + ret$n_black))
    stop("Total population size is smaller than the sum of White and Black population. Check data pull!")
  
  # Caluate racial composition 
  ret %>% 
    mutate(
      p_black = n_black/n_total,
      p_white = n_white/n_total
    )
}