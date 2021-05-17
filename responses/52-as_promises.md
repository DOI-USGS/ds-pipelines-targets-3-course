#### Check your progress

Some answers to compare to your own:

_1. Inspect the console output. Which task steps (`download`, `tally`, and/or `plot`) are no longer getting built or checked? Inspect *123_state_tasks.yml* to see if you can figure out why._

The `plot` task-steps are no longer getting built or checked. They're still there in *123_state_tasks.yml*, but we're now only building the `obs_tallies` target, which depends on the `download` and `tally` steps but not on the `plot` steps. Also, the plots are no longer listed even as dependencies of the default target (`123_state_tasks`). The `download` and `tally` steps also got removed from the default target dependencies, but the default target does depend on the tallies combiner, which depends on each of the `tally` steps, which in turn depend on the `download` steps, so that's why the `tally` and `download` steps still get considered.

_2. Inspect the value of `state_tasks`. Is it what you expected?_

Here's what my `state_tasks` looks like. Your number of rows might vary slightly if you build this at a time when the available data have changed substantially, but the column structure and approximate number of rows ought to be about the same. If it looks like this, then it meets my expectations and hopefully also yours.
```
> state_tasks
# A tibble: 738 x 4
# Groups:   Site, State [6]
   Site     State  Year NumObs
   <chr>    <chr> <dbl>  <int>
 1 04073500 WI     1898    365
 2 04073500 WI     1899    365
 3 04073500 WI     1900    365
 4 04073500 WI     1901    365
 5 04073500 WI     1902    365
 6 04073500 WI     1903    365
 7 04073500 WI     1904    366
 8 04073500 WI     1905    365
 9 04073500 WI     1906    365
10 04073500 WI     1907    365
# … with 728 more rows
```

### :keyboard: Activity: Explore `as_promises`

We stuck with the name `state_tasks` in the main pipeline, but this target would now be more aptly named `obs_tallies`.

- [ ] Try changing the target name from `state_tasks` to `obs_tallies` in *remake.yml* (do a whole-word find-replace to change it everywhere it occurs in that file).

- [ ] Run `scmake()` again. What happens? Identify the line in *123_state_tasks.yml* that defines a target of the same name.

Hmm. It would be nice if we could use the same name to refer to the same information (a table of observation tallies) in both *remake.yml* and the task table, but it appears that **scipiper** won't let us. This is where the `as_promises` argument to `create_task_makefile()` comes in.

- [ ] Change `as_promises` from `FALSE` to `TRUE`. 

- [ ] Leave the `final_targets` argument alone (set to `obs_tallies`).

- [ ] Change `obs_tallies <- scmake('obs_tallies', remake_file='123_state_tasks.yml')` to `obs_tallies <- scmake('obs_tallies_promise', remake_file='123_state_tasks.yml')` (a few lines down from the call to `create_task_makefile()`).

- [ ] Rebuild `obs_tallies` from the main *remake.yml*. Now **scipiper** lets you do it, right? Check that line you identified in *123_state_tasks.yml* to see what changed.

This `as_promises=TRUE` technique is a pattern we've adopted to accommodate the fact that **scipiper** doesn't allow duplicate target names, but we kinda want them to keep our code clear. It's not perfect, but it does the trick.

Comment on this issue when you're ready to proceed.

<hr><h3 align="center">I'll respond when I see your comment.</h3>
