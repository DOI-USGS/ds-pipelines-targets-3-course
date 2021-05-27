
Now that you have learned about branching, let's add it to our code. Currently, you have 3 individual targets that will download site data from our 3 Midwest states and store in a target named with the state name. Those targets look something like this:

```r
tar_target(wi_data, get_site_data(oldest_active_sites, states[1], parameter)),
tar_target(mn_data, get_site_data(oldest_active_sites, states[2], parameter)),
tar_target(mi_data, get_site_data(oldest_active_sites, states[3], parameter)),
```

We are going to convert the code for those targets into static branching. Let's get started!

### :keyboard: Activity: Implement static branching to download data by state

#### Include appropriate packages

Now that we are using branching, our main pipeline makefile will need the `tarchetypes` package. In addition, we will use `tibble::tibble()` to define our task data.frame. Make these two packages available to the pipeline makefile by adding the following to the other library calls in `_targets.R`:

```r
library(tarchetypes)
library(tibble)
```

#### Replace state targets with branching code

To get started, copy the code below and replace your 3 individual state targets (shown above) with it.

```r
tar_map(
  values = tasks,
  tar_target(data, get_site_data(oldest_active_sites, states, parameter))
  # Insert step for tallying data here
  # Insert step for plotting data here
),
```

#### Set up your tasks

Now, you need to create an object called `tasks` to pass in for the argument `values`. This object can be a list or a data.frame/tibble and the names of the list elements or columns are used as arguments to the functions in your steps. To match the prefilled code for the `get_site_data` step, you should replace `states <- c('WI', 'MN', 'MI')` with `tasks <- tibble(states = c('WI', 'MN', 'MI'))`.

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
