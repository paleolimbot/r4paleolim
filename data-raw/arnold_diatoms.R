
library(tidyverse)
library(neotoma)
library(writexl)

# this dataset is a diatom dataset from lake armstrong, in the Adirondacks
# Longitude	-73.94404
# Latitude	44.13093
# Neotoma Site ID: 14223
# Citation Information:

# Whitehead, D.R., D.F. Charles, S.T. Jackson, J.P. Smol, and D.R. Engstrom.
# 1989. The developmental history of Adirondack (NY) lakes. Journal of
# Paleolimnology 2(3):185-206.

arnold_dataset <- neotoma::get_dataset(14223) %>%
  map(get_download)

arnold_counts <- bind_cols(
  arnold_dataset[[2]] %>% ages() %>% .[[1]] %>% as_tibble() %>% 
    select(depth_cm = depth, age_bp = age),
  arnold_dataset[[2]] %>% counts() %>% .[[1]] %>% as_tibble()
)

arnold_counts %>%
  select(-age_bp) %>%
  gather(-depth_cm, key = "taxon", value = "valve_count") %>%
  spread(key = depth_cm, value = valve_count) %>%
  write_xlsx("data/lake_arnold_valve_counts.xlsx")

arnold_counts %>%
  write_xlsx("data/lake_arnold_valve_counts_tidy.xlsx")

arnold_counts %>%
  select(depth_cm, age_bp) %>%
  write_xlsx("data/lake_arnold_age_depth.xlsx")
