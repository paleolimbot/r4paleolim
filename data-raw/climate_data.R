
library(tidyverse)

ecdata <- function(locs, ...) {
  rclimateca::getClimateData(locs, ..., nicenames = TRUE) %>%
    left_join(rclimateca::ecclimatelocs %>% 
                select(station_name = Name, stationid = `Station ID`, province = Province),
              by = "stationid") %>%
    select(station_name, province, year, month, date = parseddate, ends_with("temp"), ends_with("precip")) %>%
    set_names(., stringr::str_replace(names(.), "(temp|precip)$", "_\\1") %>%
                stringr::str_replace("(max|min)", "_\\1")) %>%
    mutate(station_name = stringr::str_to_title(station_name)) %>%
    mutate(province = stringr::str_to_title(province)) %>%
    as_tibble()
}

eclocs <- function(locs) {
  # get locations
  rclimateca::ecclimatelocs %>%
    filter(`Station ID` %in% locs) %>%
    select(station_id = `Station ID`, station_name = Name, province = Province,
           elevation_m = `Elevation (m)`, latitude = `Latitude (Decimal Degrees)`,
           longitude = `Longitude (Decimal Degrees)`) %>%
    mutate(station_name = stringr::str_to_title(station_name)) %>%
    as_tibble()
}

# get data, write to canada_climate.csv
canada_climate <- ecdata(c(5051, 5345, 735L, 3912, 2925, 6206, 2205, 6454, 
                         1586, 1650, 6693, 1786, 6527)) %>%
  write_csv("data/canada_climate.csv")

canada_climate_locations <- eclocs(c(5051, 5345, 735L, 3912, 2925, 6206, 2205, 6454, 
                                     1586, 1650, 6693, 1786, 6527)) %>%
  write_csv("data/canada_climate_locs.csv")

# write kentville, greenwood data for 2000 to 2003
valley_climate <- ecdata(c(27141, 6354), year = 2000:2003) %>%
  write_csv("data/valley_climate.csv") %>%
  write_tsv("data/valley_climate.tsv")

# I've modified the xlsx file by hand to make it more realistic (dates as dates...)
# writexl::write_xlsx(valley_climate, "data/valley_climate.xlsx")



