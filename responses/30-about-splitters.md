In the last issue you noted a lingering inefficiency: When you added Illinois to the `states` vector, your branching pipeline built `nwis_data_WI`, `nwis_data_MN`, and `nwis_data_MI` again even though there was no need to download those files again. This happened because those three targets each depend on `oldest_active_sites`, the inventory target, and that target changed to include information about a gage in Illinois. As I noted in that issue, it would be ideal if each task branch only depended on exactly the values that determine whether the data need to be downloaded again. But we need a new tool to get there: a **splitter**.

The splitter we're going to create in this issue will split `oldest_active_sites` into a separate table for each state. In this case each table will be just one row long, but there are plenty of situations where the inputs to a set of tasks will be larger, even after splitting into task-size chunks. Some splitters will be quick to run and others will take a while, but either way, we'll be saving ourselves time in the overall pipeline!

### Background

#### The object way to split

So far in our pipeline, we already have an object that contains the inventory information for all of the states, `oldest_active_sites`. Now, we can write a splitter to take the full inventory and one state name and return a one-row table.

```r
get_state_inventory <- function(sites_info, state) {
  site_info <- dplyr::filter(sites_info, state_cd == state)
}
```
And then we could insert an initial branching step where we pulled out that state's information before passing it to the next step, such that our `tar_map()` call would look like:
```r
tar_map(
  values = tibble(state_abb = states),
  tar_target(nwis_inventory, get_state_inventory(sites_info = oldest_active_sites, state_abb)),
  tar_target(nwis_data, get_site_data(nwis_inventory, state_abb, parameter))
)
```

#### The file way to split

The "object way to split" described above works well in many cases, but note that `get_state_inventory()` is called for each of our task targets (so each state). Suppose that `oldest_active_sites` was a file that took a long time to read in - we've encountered cases like this for large spatial data files, for example - you'd have to re-open the file for each and every call to `get_state_inventory()`, which would be excruciatingly slow for a many-state pipeline. If you find yourself in that situation, you can approach "splitting" with files rather than objects.

Instead of calling `get_state_inventory()` once for each state, we could and write a single **splitter** function that accepts `oldest_active_sites` and writes a single-row table for each state. It will be faster to run because there will not be redundant reloading of the data that is needing to be split. This type of splitter would not be within your branching code and instead return a single summary table describing the state-specific files that were just created. 

For this next exercise, the object method for splitting described before will suit our needs just fine. There is no need to create a single splitter function that saves state-specific files for now. We are mentioning it here so that you can be aware of the limitations of splitters and be aware that other options exist.

#### Your mission

In this issue you'll create a splitter to make your task table more efficient in the face of a changing inventory in `oldest_active_sites`. Your splitter function will generate separate one-row inventory data for each state.

Ready?
