# Plot the number of observations per year for each site
plot_data_coverage <- function(oldest_site_tallies, out_file, parameter) {
  parameter_name <- c('00060'='discharge', '00010'='temperature')[parameter]
  oldest_site_tallies %>%
    mutate(NumObsBin = cut(NumObs, breaks=c(0,100,200,300,364,366))) %>%
    ggplot(aes(x=Year, y=sprintf('%s-%s', State, Site), fill=NumObsBin)) + geom_tile() +
    ylab('State-Site') +
    ggtitle(sprintf('Observation counts for champion %s sites', parameter_name)) +
    scale_fill_brewer('Obs per Year') + theme_bw() -> p
  ggsave(out_file, plot=p, width=8, height=10)
  return(out_file)
}
