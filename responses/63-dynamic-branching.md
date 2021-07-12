You've just run a fully functioning pipeline with 212 unique branches (53 states x 4 steps)! Imagine if you had coded that with a `for` loop and just one of those states threw an error? :grimacing:

Now that you have your pipeline running with static branching, let's try to convert it into the other type of branching, dynamic. 

### :keyboard: Activity: Switch to dynamic branching

In our scenario, it doesn't matter too much whether we pick static or dynamic branching. Both can work for us. I chose to show you static first because inspecting and building pipelines with dynamic branching can be more mysterious. In dynamic branching, the naming given to each branch target is assigned randomly and dynamic branch targets do not appear in the diagram produced by `tar_visnetwork()`. But despite those inconveniences, dynamic branching is needed in many situations in order to build truly robust pipelines, so here we go ...

#### Convert to dynamic branching

- [ ] First, let's drop back down to just a few states while we get this new branching set up. Change to `states <- c('WI', 'MN', 'MI')` and run `tar_destroy()` to reset our pipeline.

- [ ] We no longer need to use `tar_map()` to create a separate object containing our static branching output. In dynamic branching, we just add to individual `tar_target()` calls. We will move each of the four targets from `tar_map()` into the appropriate targets list individually. First, copy your "splitter" target `nwis_inventory` into `p1_targets` just after `oldest_active_sites`.

- [ ] Let's adjust this target to follow dynamic branching concepts. In dynamic branching, the output of each target is always combined back into a single object. So, `filter()`ing this dataset by state is not actually going to do anything. Instead of splitting the data apart by a branching variable (remember we used `tibble(state_abb = states)`?) as we do in static branching, we will use the `state_cd` column from `oldest_active_sites` as a grouping variable in preparation of subsequent targets that will be applied over those groups. You need to then add a special *targets* grouping (`tar_group()`) for it to be treated appropriately. Lastly, the default "iteration" in dynamic branching is by list, but we just set it up to use groups, so we need to change that. In the end, your "splitter" target should look like this:

  ```r
  tar_target(nwis_inventory,
            oldest_active_sites %>%
             group_by(state_cd) %>%
             tar_group(),
           iteration = "group")
  ```

- [ ] Now to download the data! Copy your `tar_target()` code for the `nwis_data` target and paste as a target in `p1_targets` after your `nwis_inventory` target. Make two small changes: replace `state_abb` with `nwis_inventory$state_cd` & add `pattern = map(nwis_inventory)` as an argument to `tar_target()`. This second part is what turns this into a dynamic branching target. It will apply the `retry(get_site_data())` call to each of the groups we defined in `nwis_inventory`. Continuing this idea, we can still get the state abbreviation to pass to `get_site_data()` by using the `state_cd` column from `nwis_inventory`. Since we grouped by `state_cd`, this will only have the one value.

- [ ] Add the tallying step. Copy the `tar_target()` code for the `tally` target into `p2_targets`. Add `pattern = map(nwis_data)` as the final argument to `tar_target()` to set that up to dynamically branch based on the same branching from the `nwis_data` target. 

- [ ] Since dynamic branching automatically combines the output into a single object, the `tally` target already represents the combined tallies per state. We no longer need `obs_tallies`! Delete that target :) Make sure you update the downstream targets that dependend on `obs_tallies` and have them use `tally` instead (just `data_coverage_png` in our case).

- [ ] We are on our final step to convert to dynamic branching - our timeseries plots. This is a bit trickier because we were using our static branching `values` table to define the PNG filenames, but now won't have available to us. Instead, we will build them as part of our argument directly in the function. Replace `state_plot_files` in the `plot_site_data()` command with the `sprintf()` command from `tar_map()` that creates the string with the filename. Replace `state_abb` with `unique(nwis_data$State)`. Add `pattern = map(nwis_data)` as the final argument to `tar_target`.

- [ ] Once again, dynamic branching will automatically combine the output into a single object. For file targets, that means a vector of the filenames. So, we need to change our `summary_state_timeseries_csv` target to take advantage of that. First, it can be a regular `tar_target()`, so replace `tar_combine()` with `tar_target()`. Next, delete `mapped_by_state_targets[[4]]` so that the very next argument to `tar_target()` is the command. Edit the second argument to the command to be `timeseries_png` instead of `!!!.x`. Note that I didn't ask you to add `pattern = map()` to this function. We don't need to add `pattern` here because we want to use the combined target as input, not each individual filename.

- [ ] We need to adjust the function we used in that last target because it was setup to handle the output from static branching step, not a dynamic one. There are two differences: 1) the static branching output for the filenames was not a single object, but a collection of objects (hence, `...` as our second argument for `summarize_targets()`), and 2) the individual filenames are known by the static branching approach, but only the hashed target names for the files are known in the dynamic branching approach. To fix the first difference, go to the `3_summarize/src/summarize_targets.R` file and update the function to accept a vector of filenames rather than multiple vectors. To fix the second difference, go back to your `_targets.R` file and add `names()` around the input `timeseries_png`. This passes in the targets name for the dynamically created files, not just the filenames. Otherwise, `tar_meta()` won't know what you are talking about. The last note is that *targets* v0.5.0.9000 complains about passing in a vector as "ambiguous". You can fix this by wrapping your file vector argument used in `tar_meta()` with `all_of()` in your `summarize_targets()` function to get rid of the message.

- [ ] Clean up! Delete any of the remaining static branching content. Delete the code that creates `mapped_by_state_targets` and also remove `mapped_by_state_targets` from the final targets vector at the bottom of `_targets.R`.

#### Test

- [ ] Run `tar_visnetwork()` and inspect your pipeline diagram. Do the steps and dependencies make sense?

- [ ] Now run `tar_make()`. Remember that we set this up to use only three states at first. What do you notice in your console as the pipeline builds with respect to target naming?

- [ ] Once your pipeline builds using dynamic branching across three states, change your `states` object back to the full list,

```r
states <- c('AL','AZ','AR','CA','CO','CT','DE','DC','FL','GA','ID','IL','IN','IA',
            'KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH',
            'NJ','NM','NY','NC','ND','OH','OK','OR','PA','RI','SC','SD','TN','TX',
            'UT','VT','VA','WA','WV','WI','WY','AK','HI','GU','PR')
```

- [ ] Run `tar_visnetwork()`. Is it the same or different since updating the states?

- [ ] Time to test the full thing! Run `tar_make()`. Since we used `tar_destroy()` between the last full state build and now, it will take awhile (~ 10 min).

#### Commit

- [ ] Commit and push your changes to GitHub. No need to make a PR yet, though; we'll keep working on this issue for a few more minutes first before getting human feedback.

Once you've committed and pushed your changes to GitHub, comment about some of the differences you notice when running this pipeline using the dynamic branching approach vs our original static branching approach. Include a screenshot of the result in your viewer from your last `tar_visnetwork()` showing your dynamic branching pipeline.

<hr><h3 align="center">I'll respond when I see your comment.</h3>
