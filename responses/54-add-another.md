Great, you have a combiner hooked up from start to finish, and you probably learned some things along the way! It's time to add a second combiner that serves a different purpose - here, rather than produce a target that _contains_ the data of interest, we'll produce a combiner target that _summarizes_ the outputs of interest (in this case the state-specific .png files we've already created).

### :keyboard: Activity: Add a summary combiner

#### Don't write another combiner

Last time, you wrote your own combiner. This time you just need to check out `combine_to_ind()`, a function provided by **scipiper**.

- [ ] Check out the documentation at `?combine_to_ind`.

- [ ] Test it out with a command such as
  ```r
  combine_to_ind('test.yml', '3_visualize/out/timeseries_IA.png', '3_visualize/out/timeseries_MN.png')
  ```
  Check out the contents of *test.yml*. Then when you're feeling clear on what happened, delete *test.yml*.

#### Prepare the task plan and task makefile to use `combine_to_ind()`

- [ ] Add/edit the values of the `final_targets` and `finalize_funs` arguments in the `create_task_makefile()` call to specify that you want a *second* combiner target that runs the function `combine_to_ind()` and produces a file target named `3_visualize/out/timeseries_plots.yml`. Keep the tallies combiner in place.

- [ ] Add another line just below `obs_tallies <- scmake('obs_tallies_promise', remake_file='123_state_tasks.yml')` to build this second combiner. The new line should be:
  ```r
  scmake('timeseries_plots.yml_promise', remake_file='123_state_tasks.yml')
  ```
  Note how the target name for this combiner differs from the target you provided in `final_targets`: it's the filename without the directories, and there's `_promise` at the end. This is the work of `as_promises=TRUE` again, this time as applied to a file target.

- [ ] Run `scmake()`. It breaks. Check out the combiner targets at the end of *123_state_tasks.yml* to see if you can figure out why before you read the instructions in the next paragraph.

#### Test and revise `final_steps`

Hmm, you probably just discovered that *123_state_tasks.yml* is trying to apply `combine_to_ind()` to your `tally` step instead of your `plot` step:
```r
  timeseries_plots.yml_promise:
    command: combine_to_ind(I('3_visualize/out/timeseries_plots.yml'),
      `WI_tally`,
      `MN_tally`,
      `MI_tally`,
      `IL_tally`,
      `IN_tally`,
      `IA_tally`)
```

In hindsight, that probably makes sense, but it makes the next step a bit tricky. You've already set `final_steps='tally'` in `create_task_plan()`, and that's still useful for the tally combiner. But in order to pass the plot files into `combine_to_ind()`, which is what we need for this new combiner, we'd really like `final_steps='plot'`. 

- [ ] Set the `final_steps` argument of your call to `create_task_plan()` to `c('tally', 'plot')`, call `scmake()` again, and check out *123_state_tasks.yml* once more. How did the combiner functions change?

Hmm, that's an improvement because now both combiners are getting the arguments they need, but it's also a step backward brecause now neither combiner is getting *only* the arguments it needs - they're each getting both the `tally` and the `plot` outputs.

#### Revise the combiners

The solution for this multi-combiner pipeline is to filter the arguments in each combiner. For this particular pipeline, we can distinguish between the two final steps based on their type: the `tally` outputs are `tibble` types, and the `plot` outputs get passed to the combiner as `character` filenames.

- [ ] For `combine_obs_tallies()`, add these two lines to the beginning of the function:
  ```r
  # filter to just those arguments that are tibbles (because the only step
  # outputs that are tibbles are the tallies)
  dots <- list(...)
  tally_dots <- dots[purrr::map_lgl(dots, is_tibble)]
  ```
  and then proceed with whatever code you were using to combine the tibbles, this time using `tally_dots` rather than `...`. Depending on the function you used for the combining, you may need to revise that code slightly to take a single argument that's a list of tibbles, rather than a sequence of individual tibble arguments.

- [ ] For `combine_to_ind()`, it turns out you will need to write your own custom function after all so that you can add in this filtering. Try adding this function to *123_state_tasks.R*:
  ```r
  summarize_timeseries_plots <- function(ind_file, ...) {
    # filter to just those arguments that are character strings (because the only
    # step outputs that are characters are the plot filenames)
    dots <- list(...)
    plot_dots <- dots[purrr::map_lgl(dots, is.character)]
    do.call(combine_to_ind, c(list(ind_file), plot_dots))
  }
  ```
  Then replace `'combine_to_ind'` with `'summarize_timeseries_plots'` in the `finalize_funs` argument to `create_task_makefile()`.

- [ ] Run `scmake()` again and then check the contents of *3_visualize/out/data_coverage.png* and *3_visualize/out/timeseries_plots.yml* to make sure you've succeeded in hooking up both combiners.

When you're feeling confident, add a comment to this issue with the contents of *3_visualize/out/data_coverage.png* and *3_visualize/out/timeseries_plots.yml*.

<hr><h3 align="center">I'll respond when I see your comment.</h3>
