### :keyboard: Activity: Create a separate inventory for each state

- [ ] Add a new target to your `tar_map()` call just before the `nwis_data` target but below the `values` input using this boilerplate:
  ```r
  tar_target(nwis_inventory, ),
  ```

- [ ] Add a code to subset the rows in `oldest_active_sites` based on the branching variable, `state_abb`. Remember that `oldest_active_sites` has a column called `state_cd` containing the state abbreviations. Hint: go peek at the first line of the function `get_site_data()` in `1_fetch/src/get_site_data.R`.

- [ ] Edit your call for the `nwis_data` target to use `nwis_inventory` instead of `oldest_active_sites` to take advantage of your newly split data.

- [ ] Lastly, the first step in `get_site_data()` that filters the input data is not longer needed (because that is taken care of in your new splitter step!). But careful - the incoming data is an argument called `sites_info` but the rest of the function relies on `site_info` (singular `site` not `sites`). So, delete that first line but then update the argument name to be singular, `site_info`. Now you are good :)

#### Test

When you think you've got it right, run your pipeline again!
```r
tar_make()
```

You should now see targets being built called `nwis_inventory_WI`, `nwis_inventory_IL`, etc. It should redownload all of the data for WI, MN, MI, and IL (so rebuild `nwis_data_WI`, `nwis_data_MI`, etc) because we changed the inputs and the function for those targets. The real magic comes next.

If you're not quite getting the build to work, keep editing until you have it (but remember that there may still be "internet transfer failures" which require you to run `tar_make()` a few times). When you've got it, copy and paste the console output of `tar_make()` and `tar_visnetwork()` into a comment on this issue.

<hr><h3 align="center">I'll respond when I see your comment.</h3>
