### :keyboard: Activity: Add a data combiner

#### Write `combine_obs_tallies()`

- [ ] Add a new function called `combine_obs_tallies` somewhere in *123_state_tasks.R*. The function declaration should be `function(...)`; when the function is actually called, you can anticipate that the arguments will be a bunch of tallies tibbles (**tidyverse** data frames). Your function should return the concatenation of these tibbles into one very tall tibble.

- [ ] Test your `combine_obs_tallies()` function. Run
  ```r
  source('123_state_tasks.R') # load `combine_obs_tallies()`
  WI_tally <- remake::fetch('WI_tally', remake_file='123_state_tasks.yml')
  MN_tally <- remake::fetch('MN_tally', remake_file='123_state_tasks.yml')
  IA_tally <- remake::fetch('IA_tally', remake_file='123_state_tasks.yml')
  combine_obs_tallies(WI_tally, MN_tally, IA_tally)
  ```
  The result should be a tibble with four columns and as many rows as the sum of the number of rows in `WI_tally`, `MN_tally`, and `IA_tally`. If you don't have it right yet, keep fiddling and/or ask for help.

#### Prepare the task plan and task makefile to use `combine_obs_tallies()`

- [ ] Set the `final_steps` argument of your call to `create_task_plan()` to `'tally'` (which should be the `step_name` name of your tally step) - this tells **scipiper** to pass [only] the results of the "tally" task-steps into your combiner.

- [ ] Set `as_promises=FALSE` and `tickquote_combinee_objects=TRUE` in your call to `create_task_makefile()` within `do_state_tasks()`.

- [ ] Add/edit the values of the `final_targets` and `finalize_funs` arguments in the `create_task_makefile()` call to specify that you want one combiner target that runs the function `combine_obs_tallies()` and produces an R object target named `obs_tallies`.

#### Connect the pipeline

- [ ] Add `'123_state_tasks.R'` as yet another unnamed argument in the recipe for `state_tasks` in *remake.yml*. This exercise should be familiar; you need to specify your code sources here (and propagate them through to `create_task_makefile()` using the `...` argument to `do_state_tasks()`) so that both *123_state_tasks.yml* and *remake.yml* can see them.

- [ ] Edit the `# Build the tasks` code chunk within `do_state_tasks` so that the target that gets built is `obs_tallies` and the output is assigned to a local variable also named `obs_tallies`.

- [ ] Return `obs_tallies` as the output of `do_state_tasks()`. Change the `# Return nothing...` comment to match what you're now doing.

#### Test

Run `state_tasks <- scmake('state_tasks')`, then answer these questions:

1. Inspect the console output. Which task steps (`download`, `tally`, and/or `plot`) are no longer getting built or checked? Inspect *123_state_tasks.yml* to see if you can figure out why.

2. Inspect the value of `state_tasks`. Is it what you expected?

When you're feeling confident, add a comment to this issue with your answers to the two questions above.

<hr><h3 align="center">I'll respond when I see your comment.</h3>
