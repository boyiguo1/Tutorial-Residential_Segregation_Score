# Required libraries
## All of them should be on CRAN
library(tidyverse)
library(drake)

# Load helper functions
## Please set the working directory to current file's location
## setwd("S:/Regards/analysis/BoyiGuo/Residential Segregation")
# source("Code/pull_2000_census_track_data.R")
source("Code/calc_RS_indices.R")




my_plan <- drake_plan(
  
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
  save_dat = write.table(county_RS_dat, file_out("Data/county_level_RS_indices.csv"),
                         row.names = F, sep=",")
  
)

# Plot the flowchart of my_plan
vis_drake_graph(my_plan)

# Implement my plan
make(my_plan)
