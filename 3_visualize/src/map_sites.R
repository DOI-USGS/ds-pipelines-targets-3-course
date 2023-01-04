map_sites <- function(out_file, site_info) {
  state_polys <- urbnmapr::get_urbn_map(map = "territories_states", sf = FALSE) %>%
    filter(state_abbv %in% site_info$state_cd)

  age_limits <- range(site_info$begin_date)
  age_breaks <- seq(age_limits[1], age_limits[2], by=20*365.25)
  age_labels <- format(age_breaks, '%Y')

  beyond_abbv <- c('HI','AK','GU','PR')
  conus_polys <- state_polys %>% filter(!(state_abbv %in% beyond_abbv))
  conus_sites <- site_info %>% filter(
    state_cd %in% state_polys$state_abbv, !(state_cd %in% beyond_abbv))
  conus <- ggplot(conus_polys, aes(long, lat, group = group)) +
    geom_polygon(fill = "lightgrey", color = "#ffffff", size = 0.25) +
    geom_point(data=conus_sites, aes(y=dec_lat_va, x=dec_long_va, color=begin_date), group=NA) +
    theme_map() + theme(legend.position = 'right') +
    coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
    scale_color_date(name='Begin Date', limit=age_limits, breaks=age_breaks, labels=age_labels)

  # plot the other states
  beyond_sites <- site_info %>% filter(state_cd %in% beyond_abbv)
  if(nrow(beyond_sites) > 0) {
    world <- ne_countries(scale = "medium", returnclass = "sf")
    beyond <- ggplot(world) +
      geom_sf(fill = "lightgrey", color = "#ffffff", size = 0.25) +
      geom_point(data=beyond_sites, aes(y=dec_lat_va, x=dec_long_va, color=begin_date), group=NA) +
      theme_map() +
      scale_color_date(name='Begin Date', guide='none', limit=age_limits, breaks=age_breaks, labels=age_labels)

    # combine conus and non-conus and save
    combo <- cowplot::plot_grid(conus, beyond, nrow=2)
    ggsave(out_file, plot=combo, width=8, height=7)
  } else {
    # save just conus to file
    ggsave(out_file, plot=conus, width=5, height=4)
  }

  return(out_file)
}
