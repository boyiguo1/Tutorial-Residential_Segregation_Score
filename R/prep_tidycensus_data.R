prep_tidycensus_data <- function(raw_dat){
  
  # Rename the variables from code name
  ret <- raw_dat %>%
    rename_all(tolower) #%>% 
  
  # Error prevention
  if(any(is.na(ret$variable)))
    stop("Unknown code name exists")
  
  # Convert from long table to wide table
  ret %<>%
    pivot_wider(names_from = variable,
                values_from = value) %>% 
    filter(n_total != 0)
  
  # Error Prevention
  if(any(ret$n_total < ret$n_majority + ret$n_minority))
    stop("Total population size is smaller than the sum of Majority and Minority population. Check data pull!")
  
  # Calculate racial composition 
  ret %>% 
    mutate(
      p_minority = n_minority/n_total,
      p_majority = n_majority/n_total
    )
}