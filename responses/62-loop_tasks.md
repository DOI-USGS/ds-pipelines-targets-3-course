### :keyboard: Activity: Use `loop_tasks`

Rather than babysitting repeated `scmake()` calls until all the states build, it's time to try another option for building a task table: the `loop_tasks()` function. This **scipiper** function is designed to provide fault tolerance for tasks such as this data pull (including those where the "failures" are all real rather than being largely synthetic as in this project :wink:).

#### Expand `states`

- [ ] Within `do_state_tasks()`, insert a call to `loop_tasks` just after `# Build the tasks` and just before the calls to `scmake('obs_tallies')` and `scmake('timeseries_plots_info')`. Use the documentation at `?loop_tasks` to figure out how to pass in the task plan information (first two arguments); leave `task_steps=NULL` and `step_names=NULL`.

- [ ] Adjust the `num_tries` argument if desired to make it even more likely that you'll just need one call to `scmake()` next time. It's usually fine for `num_tries` to be higher than needed; the looping will stop once all tasks are complete.

- [ ] Leave `n_cores = 1` to avoid overloading NWIS Web or your local network with multiple simultaneous HTTP requests. But note that you could set this to a higher number if your task plan included local processing tasks that would go faster with local parallelization.

- [ ] Replace the line
  ```r
  obs_tallies <- scmake('obs_tallies_promise', remake_file='123_state_tasks.yml')
  ```
  with this line:
  ```r
  obs_tallies <- remake::fetch('obs_tallies_promise', remake_file='123_state_tasks.yml')
  ```
  and add `remake` to the packages list in *remake.yml* because we're calling a function from that package now. This switch from `scmake` to `fetch` is possible because `loop_tasks()` will have already ensured that `obs_tallies_promise` is up to date, so we can use a simple `fetch` (which doesn't take time to check for currentness) to copy `obs_tallies` into the local environment before `return()`ing it to the main pipeline.

- [ ] Remove the call to `scmake('timeseries_plots.yml_promise')` because `loop_tasks()` will have already ensured that `timeseries_plots.yml_promise` is up to date. Keep the call to `yaml::yaml.load_file()`, though, because we need to create `timeseries_plot_info` so we can `return()` it to the main pipeline.

#### Test

_Note: When you next run `scmake()`, you might or might not hit an issue that I was sometimes seeing when developing this course: the build might do just fine right up until the first combiner, at which point you may see see_
```r
Error: hash 'b18f3d9c360f89665bf89fdeb945cb16' not found
```
_(where the exact hash value will differ for you). I think the issue might have to do with interrupting a build partway through (I may have been impatient with an `scmake()` call or two), but I can't fully pin it down yet, and we don't always see the error. If you do see this error, I'm afraid the only solution I've found is to delete the *.remake* folder and run `scmake()` again from scratch. On the bright side, that will give you time to check your email, say something nice to a coworker, etc._

- [ ] Run `scmake()`. Note the different console messages this time. Grab a tea or coffee if you like - it's a long run (~7-minutes), but at least there's no babysitting needed!

#### Commit

- [ ] Commit and push your changes to GitHub. No need to make a PR yet, though; we'll keep working on this issue for a few more minutes first before getting human feedback.

Comment once you've committed and pushed your changes to GitHub.

<hr><h3 align="center">I'll respond when I see your comment.</h3>
