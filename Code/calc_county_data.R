calc_county_data <- function(tract_dat){
  
  tract_dat %>% group_by(state, county) %>% 
    summarise(cnty_total = sum(total),
              cnty_white = sum(white),
              cnty_black = sum(black),
              cnty_other = sum(other),
              .group = "drop")
  
  }