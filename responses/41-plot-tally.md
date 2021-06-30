### :keyboard: Activity: Add two new appliers

#### Code

In *_targets.R*:

- [ ] Add a new step right after `nwis_data`. It should create R object targets called `tally_WI`, `tally_MI`, etc., should call the `tally_site_obs()` function (also already defined for you in *2_process/src/tally_site_obs.R*), and should make use of the targets created in `nwis_data`.

- [ ] We are about to add a third step to our static branching, where we create plot image files. First, we want to add our new file names to our branches defined in `values`. Add another column to the tibble called `state_plot_files` that includes *3_visualize/out/timeseries_WI.png*, *3_visualize/out/timeseries_MN.png*, etc. by editing`tibble(state_abb = states)` to be

```r
tibble(state_abb = states) %>% 
  mutate(state_plot_files = sprintf("3_visualize/out/timeseries_%s.png", state_abb))
```

- [ ] Add a third step to plot the data. This step should have a target name of `timeseries_png`, should call the `plot_site_data()` function (defined in *3_visualize/src/plot_site_data.R*), should use the image filename for each task stored in the `state_plot_files` column, and should make use of the targets created in `nwis_data` (no need to link to the `tally` targets).

- [ ] Make the two new function files (where `plot_site_data()` and `tally_site_obs()` are defined) available to the pipeline by adding `source()` calls to `_targets.R`.

- [ ] The `tally_site_obs()` function uses a function from the package **lubridate**. Add this package to the `packages` argument in your `tar_option_set()` call.

- [ ] Speaking of packages, we added `%>%` and `mutate` to `_targets.R` in order to add a new column to our task tibble. These are made available by the `dplyr` package which is included in `tidyverse`, and while `tidyverse` is loaded in `tar_option_set()`, it is not loaded when the top-level makefile is run. So, we need to add `library(dplyr)` to the top of `_targets.R`.

- [ ] Now that we have added an additional column in `values`, we have less certainty about what `tar_map()` will use as the suffix when naming branch targets. To control what is used as the suffix, you can specify what part of `values` to use by passing in the column name to the `names` argument within `tar_map()`. This guarantees that `_WI`, `_MN`, etc will be used and not the long image filenames (that could get messy!). Go ahead and add `names = state_abb` as the final argument to `tar_map()`.

#### Test

- [ ] Run `tar_make()`. Is it building a timeseries plot and a `tally` object for each state? If not, keep fiddling with your code until you get it to work.

- [ ] Check the contents of the *3_visualize/out* directory and inspect at least one of the plots. How do they look?

- [ ] Load the value of `tally_IL` to a variable of the same name in your global environment (hint: `?tar_load()`)

When you're feeling confident, add a comment to this issue with:
* an image from one of the new plots in *3_visualize/out*, and
* a printout of the first 10 lines of `tally_IL`.

<hr><h3 align="center">I'll respond when I see your comment.</h3>
