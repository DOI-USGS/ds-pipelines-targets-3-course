### :keyboard: Activity: Add two new appliers

#### Code

In *123_state_tasks.R*:

- [ ] Add a new step right after `download_step`. This step object should be called `plot_step`, should have step name `'plot'`, should create targets called *3_visualize/out/timeseries_WI.png*, *3_visualize/out/timeseries_MN.png*, etc., should call the `plot_site_data()` function (defined in *3_visualize/src/plot_site_data.R*), and should make use of the targets created in `download_step`.
  _(Hint: It's fine to link backward to the downloading targets using `sprintf()` or another string manipulation function, but if you want to get really fancy, try out the `steps` argument to your `command` function.)_

- [ ] Add a third step called `tally_step`. This step should have step name `'tally'`, should create R object targets called `WI_tally`, `MI_tally`, etc., should call the `tally_site_obs()` function (also already defined for you), and should make use of the targets created in `download_step` (no need to link to the `plot_step` targets).

- [ ] Add `plot_step` and `tally_step` to the call to `create_task_plan()`.

- [ ] Add the two new function files (where `plot_site_data()` and `tally_site_obs()` are defined) to the `sources` argument in your `create_task_makefile()` call.

- [ ] Add the **lubridate** package to the `packages` argument in your `create_task_makefile()` call (it's used in `tally_site_obs()`).

#### Test

- [ ] Run `scmake('state_tasks')`. Is it building a timeseries plot and a `tally` object for each state? If not, keep fiddling with your code until you get it to work.

- [ ] Check the contents of the *3_visualize/out* directory and inspect at least one of the plots. How do they look?

- [ ] Assign the value of `IN_tally` to a variable of the same name in your global environment. You can use the `scipiper::scmake()` function or the `remake::fetch()` function. Either function will require a bit of special syntax - review `?scmake` or `?remake::fetch` for clues and ask if you get stuck.

When you're feeling confident, add a comment to this issue with:
* an image from one of the new plots in *3_visualize/out*, and
* a printout of the first 10 lines of `IN_tally`.

<hr><h3 align="center">I'll respond when I see your comment.</h3>
