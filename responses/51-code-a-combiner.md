### :keyboard: Activity: Add a data combiner

#### Write `combine_obs_tallies()`

- [ ] Add a new function called `combine_obs_tallies` somewhere in *2_process/src/tally_site_obs.R*. The function declaration should be `function(...)`; when the function is actually called, you can anticipate that the arguments will be a bunch of tallies tibbles (**tidyverse** data frames). Your function should return the concatenation of these tibbles into one very tall tibble.

- [ ] Test your `combine_obs_tallies()` function. Run
  ```r
  source('2_process/src/tally_site_obs.R') # load `combine_obs_tallies()`
  tar_load(tally_WI)
  tar_load(tally_MN)
  tar_load(tally_IL)
  combine_obs_tallies(tally_WI, tally_MN, tally_IL)
  ```
  The result should be a tibble with four columns and as many rows as the sum of the number of rows in `WI_tally`, `MN_tally`, and `IL_tally`. If you don't have it right yet, keep fiddling and/or ask for help.

#### Prepare the makefile to use `combine_obs_tallies()`

- [ ] Break up the single list of targets into 3 separate objects: one for `oldest_active_sites`, one for the whole static branching `tar_map()` called `state_branches`, and one for `site_map_png`. 

- [ ] Add a call to `list()` at the bottom of the makefile to combine these new individual target objects into one list of targets.

- [ ] Add `unlist=FALSE` to your `tar_map()` call, so that we can reference only the branch targets from the `tally` step in `tar_combine()`.

#### Add your combiner target

- [ ] Add a target object between your `tar_map()` call and the `site_map_png` target. This target should use `tar_combine()` and the output should be saved to a local object.

- [ ] Edit the list at the bottom of your makefile to include the object output from `tar_combine()`.

- [ ] Populate your `tar_combine()` call with the target name `obs_tallies`, input for just the tally branches by subsetting the `tar_map()` output object, and the appropriate call to `combine_obs_tallies()` for the `command`.

#### Test

Run `tar_make()` and then `tar_load(obs_tallies)`. Inspect the value of `obs_tallies`. Is it what you expected?

When you're feeling confident, add a comment to this issue with your answers to the question above.

<hr><h3 align="center">I'll respond when I see your comment.</h3>
