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

- [ ] Move your static branching setup outside of your targets list and save above as an object called `mapped_by_state_targets`. It should look something like
  ```r
  mapped_by_state_targets <- tar_map(...)
  
  list(
    tar_target(oldest_active_sites, ...),
    
    tar_target(site_map_png, ...)
  )
  ```

- [ ] Now add `mapped_by_state_targets` as a target between `oldest_active_sites` and `site_map_png` in your list of targets.

- [ ] Add `unlist=FALSE` to your `tar_map()` call, so that we can reference only the branch targets from the `tally` step in `tar_combine()`.

#### Add your combiner target

- [ ] Add a new target between `mapped_by_state_targets` and the `site_map_png` target called `obs_tallies`. Instead of `tar_target()`, this will use `tar_combine()`.

- [ ] Populate your `tar_combine()` call with input for just the tally branches by subsetting the `tar_map()` output object, and the appropriate call to `combine_obs_tallies()` for the `command` (remember you will need `!!!.x`).

#### Test

Run `tar_make()` and then `tar_load(obs_tallies)`. Inspect the value of `obs_tallies`. Is it what you expected?

When you're feeling confident, add a comment to this issue with your answer to the question above.

<hr><h3 align="center">I'll respond when I see your comment.</h3>
