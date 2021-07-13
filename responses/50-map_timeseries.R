map_timeseries <- function(site_info, plot_info_csv, out_file) {
  # libraries: leaflet, leafpop, htmlwidgets

  # prepare data
  map_data <- readr::read_csv(plot_info_csv, col_types=cols()) %>%
    extract(col='filepath', into='state_cd', regex='3_visualize/out/timeseries_([[:alpha:]]{2})\\.png', remove=FALSE) %>%
    select(state_cd, filepath) %>%
    left_join(select(site_info, state_cd, site_no, station_nm, dec_lat_va, dec_long_va, count_nu), by='state_cd')

  # prepare map aesthetics
  marker_colors = c('white', 'orange', 'lightred', 'red', 'darkred')
  map_info <- map_data %>% mutate(
    color = marker_colors[cut(count_nu, seq(min(count_nu)-1, max(count_nu), length.out=length(marker_colors)+1))],
    label = sprintf('%s: %s (Site %s, %0.0f Obs)', state_cd, station_nm, site_no, count_nu))
  icons <- awesomeIcons(
    icon = 'ios-close',
    iconColor = 'black',
    library = 'ion',
    markerColor = map_info$color
  )

  # make the map
  m <- leaflet(map_info) %>%
    addTiles() %>%
    addAwesomeMarkers(
      lng = ~dec_long_va, lat = ~dec_lat_va,
      label = ~label,
      icon = icons,
      popupOptions = popupOptions(maxWidth=600, max_height=300),
      popup = leafpop::popupImage(
        map_info$filepath, src='local', embed=TRUE, height=300, width=600)
    )

  # save the map - seems to help to save to current working directory and then move
  htmlwidgets::saveWidget(m, file=basename(out_file))
  file.copy(basename(out_file), out_file, overwrite=TRUE)
  file.remove(basename(out_file))
  return(out_file)
}
