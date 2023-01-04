
library(targets)

options(tidyverse.quiet = TRUE)
tar_option_set(packages = c("tidyverse", "dataRetrieval", "urbnmapr", "rnaturalearth", "cowplot"))

# Load functions needed by targets below
source("1_fetch/src/find_oldest_sites.R")
source("3_visualize/src/map_sites.R")

# Configuration
states <- c('WI','MN','MI')
parameter <- c('00060')

# Targets
list(
  # Identify oldest sites
  tar_target(oldest_active_sites, find_oldest_sites(states, parameter)),

  # TODO: PULL SITE DATA HERE

  # Map oldest sites
  tar_target(
    site_map_png,
    map_sites("3_visualize/out/site_map.png", oldest_active_sites),
    format = "file"
  )
)
