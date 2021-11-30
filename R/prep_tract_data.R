library(UScensus2000tract)

source("Code/pull_2000_census_track_data.R")

census_tract_data <- pull_2000_census_tract_data()

if(any(is.na(census_tract_data$tract)))
  stop("Tract code that is neither 4/6 characters exists. Please verify")

write.table(census_tract_data, "Data/2000_tract_data.csv",
            sep=",", row.names = F)
