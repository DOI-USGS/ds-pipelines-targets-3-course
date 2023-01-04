find_oldest_site <- function(state, parameter) {
  message(sprintf('  Inventorying sites in %s', state))
  sites <- dataRetrieval::whatNWISdata(
    parameterCd=parameter, stateCd=state, hasDataType='dv', agencyCd='USGS',
    siteType='ST', siteStatus='active',
    startDt=format(Sys.Date()-as.difftime(7, units='days'), '%Y-%m-%d'),
    endDt=format(Sys.Date()-as.difftime(1, units='days'), '%Y-%m-%d'))

  # Remove attributes that include query times, otherwise `targets` will think it changed
  # when it rebuilds when a new state is added since the inventory builds all states again
  # using `find_oldest_sites()`
  attr(sites, "comment") <- NULL
  attr(sites, "queryTime") <- NULL
  attr(sites, "headerInfo") <- NULL

  best_site <- sites %>%
    filter(stat_cd == '00003', data_type_cd == 'dv') %>%
    filter(count_nu == max(count_nu)) %>%
    mutate(state_cd = state, alt_acy_va = as.character(alt_acy_va)) %>%
    select(state_cd, site_no, station_nm, dec_lat_va, dec_long_va, dec_coord_datum_cd, begin_date, end_date, count_nu) %>%
    slice(1) # OK has two sites tied for first; just take one
  return(best_site)
}
find_oldest_sites <- function(states, parameter) {
  purrr::map_df(states, find_oldest_site, parameter)
}
