# This is where you write your drake plan.
# Details: https://books.ropensci.org/drake/plans.html

plan <- drake_plan(
  
  # Pulling census tract data
  tract_dat = read_csv(file_in("Data/2000_tract_data.csv")),
  
  # Calculate county data by aggregating tract data
  county_dat = tract_dat %>% 
    group_by(state, county) %>% 
    summarise(total = sum(total),
              white = sum(white),
              black = sum(black),
              other = sum(other),
              .groups = "drop") %>% 
    mutate(prop_w = white/total,
           prop_b = black/total),
  
  # Calculate
  county_RS_dat = calc_RS_indices(tract_dat, county_dat),
  
  # Save data set
  save_csv = write.table(county_RS_dat, file_out("Data/county_level_RS_indices.csv"),
                         row.names = F, sep=","),
  
  # Save SAS set
  # save_sas = haven::write_sas(county_RS_dat, file_out("Data/county_level_RS_indices.sas7bdat"))
)
