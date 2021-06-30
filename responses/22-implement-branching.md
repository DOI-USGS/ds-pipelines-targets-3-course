
Now that you have learned about branching, let's add it to our code. Currently, you have 3 individual targets that will download site data from our 3 Midwest states and store in a target named with the state name. Those targets look something like this:

```r
tar_target(wi_data, get_site_data(oldest_active_sites, states[1], parameter)),
tar_target(mn_data, get_site_data(oldest_active_sites, states[2], parameter)),
tar_target(mi_data, get_site_data(oldest_active_sites, states[3], parameter)),
```

We are going to convert the code for those targets into static branching. We are going to make these changes on the "{{ branch }}" branch that we created earlier. Let's get started!

### :keyboard: Activity: Implement static branching to download data by state

#### Include appropriate packages

Now that we are using branching, our main pipeline makefile will need the `tarchetypes` package. In addition, we will use `tibble::tibble()` to define our task data.frame. Make these two packages available to the targets pipeline by adding the following to the other library calls in `_targets.R`:

```r
library(tarchetypes)
library(tibble)
```

#### Replace state targets with branching code

To get started, copy the code below and replace your 3 individual state targets (shown above) with it.

```r
tar_map(
  values = tibble(state_abb = states),
  tar_target(data, get_site_data(oldest_active_sites, state_abb, parameter))
  # Insert step for tallying data here
  # Insert step for plotting data here
),
```

#### Verify your task values

This is already set up for you, but is worth going over. Your task names are passed into `tar_map()` using the argument `values`. This argument will accept a list or a data.frame/tibble and the names of the list elements or columns are used as arguments to the functions in your steps. Rather than change the `states` object outside of `tar_map()` (because that would require us to also update `oldest_active_sites` which uses `states`), we are using that vector to create a column called `state_abb` in the `tibble` passed to `values`. That means, when we need to pass in the task names as an argument to a function, we use `state_abb`, the column name containing those task names.

#### Check your progress

You have already learned about `tar_visnetwork()` as a way to visualize your pipeline before running it. By default, it will show targets and functions. We would just like to check that our branch targets are set up appropriately, so try running `tar_visnetwork(targets_only = TRUE)` to get a visual with just targets. You should see something similar to the image below, where there are three targets prefixed with `data_`. 

![branch_targets](https://user-images.githubusercontent.com/13220910/119854642-daea5080-bed6-11eb-9c64-a4bfab5d437a.png)

Those targets prefixed with `data_` are the branches (targets per task-step) for the `get_site_data()` step. They are automatically named using the target name you pass to `tar_target()` + an `_` + the task identifier. You can test this by changing that target name from `data` to `nwis_data` and re-running `tar_visnetwork(targets_only = TRUE)`. You should now see the branches `nwis_data_MI`, `nwis_data_MN`, and `nwis_data_WI` in the visual.

You can also use a function called `tar_manifest()` to check your pipeline before running. It will return a table of information about each target and the function call that will be used to create it. Try running `tar_manifest()`. You should see

```r
# A tibble: 5 x 3
  name                command                                                            pattern
  <chr>               <chr>                                                              <chr>  
1 oldest_active_sites "find_oldest_sites(states, parameter)"                             NA     
2 nwis_data_MI        "get_site_data(oldest_active_sites, \"MI\", parameter)"            NA     
3 nwis_data_MN        "get_site_data(oldest_active_sites, \"MN\", parameter)"            NA     
4 nwis_data_WI        "get_site_data(oldest_active_sites, \"WI\", parameter)"            NA     
5 site_map_png        "map_sites(\"3_visualize/out/site_map.png\", oldest_active_sites)" NA        
```

If your pipeline doesn't look as you expect it should, keep iterating on your code in the `_targets.R` file. When you're happy with your pipeline, run `tar_manifest(starts_with('nwis_data'))` to see the details for just the branches. Copy and paste the output into a new comment on this issue.

<hr><h3 align="center">I'll respond when I see your comment.</h3>
