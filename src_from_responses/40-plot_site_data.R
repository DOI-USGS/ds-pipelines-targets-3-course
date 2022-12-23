# Plot a timeseries of data for each site individually
# packages: tidyverse
plot_site_data <- function(out_file, site_data, parameter) {
  message(sprintf('  Plotting data for %s-%s', site_data$State[1], site_data$Site[1]))
  p <- ggplot(
    filter(site_data, Quality %in% c('A','P')), aes(x=Date, y=Value, color=Quality)) +
    geom_line() +
    geom_point(data=filter(site_data, !(Quality %in% c('A','P'))), size=0.1) +
    ylab(dataRetrieval::parameterCdFile %>% filter(parameter_cd == parameter) %>% pull(parameter_nm)) +
    ggtitle(site_data$Site[1])
  ggsave(out_file, plot=p, width=6, height=3)
  return(out_file)
}
