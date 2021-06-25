# Compute number of observations per year
# packages: lubridate, tidyverse
tally_site_obs <- function(site_data) {
  message(sprintf('  Tallying data for %s-%s', site_data$State[1], site_data$Site[1]))
  site_data %>%
    mutate(Year = year(Date)) %>%
    # group by Site and State just to retain those columns, since we're already
    # only looking at just one site worth of data
    group_by(Site, State, Year) %>%
    summarize(NumObs = length(which(!is.na(Value))), .groups = "keep")
}
