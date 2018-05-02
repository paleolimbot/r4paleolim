
library(tidyverse)
library(mudata2)
library(writexl)

# this loads the "halifax_geochem*" files in the "data/" directory these data
# are from an *almost* published paper: 

# Dunnington D., Spooner I.S., Krkošek W.H., Gagnon G.A., Cornett R.J., Kurek
# J., White C.E., Misiuk B., Tymstra D. (in press). Anthropogenic activity in
# the Halifax region, Nova Scotia, Canada, as recorded by bulk geochemistry of
# lake sediments. Lake and Reservoir Management.
# doi:10.1080/10402381.2018.1461715

md_hfx <- read_mudata("data-raw/Dunnington_et_al_2018.mudata.json")

halifax_geochem_data <- md_hfx %>%
  tbl_data_wide() %>%
  select(core_id = location, depth_cm = depth, age_ad = age, 
         C_percent = C, `C/N`, d13C_permille = d13C, d15N_permille = d15N, 
         K_percent = K, Ti_percent = Ti) 

halifax_geochem_data %>%
  write_xlsx("data/halifax_geochem.xlsx")
halifax_geochem_data %>%
  write_csv("data/halifax_geochem.csv")

md_hfx %>%
  tbl_locations() %>%
  rename(core_id = location) %>%
  select(-dataset, -location_code) %>%
  write_xlsx("data/halifax_geochem_cores.xlsx")
