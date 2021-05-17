You're down to the last task for this issue! I hope you'll find this one rewarding. After all your hard work, you're now in a position to create a **leaflet** map that will give you interactive access to the locations, identities, and timeseries plots of the Upper Midwest's oldest gages, all in one .html map. Ready?

#### Use the plots downstream

- [ ] Add another target to *remake.yml* that uses the function `map_timeseries()` (defined for you in `3_visualize`). `site_info` should be the inventory of oldest sites, `plot_info` should be `timeseries_plots_info`, and the output should be written to `3_visualize/out/timeseries_map.html`.

- [ ] Add the three packages that `map_timeseries()` requires to the declaration at the top of *remake.yml*: `leaflet`, `leafpop`, and `htmlwidgets`.

- [ ] Edit *remake.yml* as need to ensure that `3_visualize/out/timeseries_map.html` will get built on a call to `scmake()` without arguments.
  _(You should already have `3_visualize/out/data_coverage.png` set up for this. Also, by declaring both `3_visualize/out/timeseries_map.html` and `3_visualize/out/data_coverage.png` as elements of the default target, you will have ensured that `obs_tallies` and `timeseries_plots_info` will get built, so you don't need to declare those directly..)_

#### Test

- [ ] Run `scmake()`. Any surprises?

- [ ] Check out the results of your new map by opening *3_visualize/out/timeseries_map.html* in the browser. You should be able to hover and click on each marker.

- [ ] Add or subtract a state from the `states` vector and rerun `scmake()`. Did you see the rebuilds and non-rebuilds that you expected? Did the html file change as expected?

#### Make a pull request

It's finally time to submit your work.

- [ ] Commit your code changes for this issue and make sure you're `.gitignore`ing the new analysis products (the .png and .html files). Push your changes to the GitHub repo.

- [ ] Create a PR to merge the "{{ branch }}" branch into "master". Share a screenshot of *3_visualize/out/timeseries_map.html* and any thoughts you want to share in the PR description. 

<hr><h3 align="center">I'll respond when I see your PR.</h3>
