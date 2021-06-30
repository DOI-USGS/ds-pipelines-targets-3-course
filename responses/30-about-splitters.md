In the last issue you noted a lingering inefficiency: When you added Illinois to the `states` vector, your branching pipeline built `nwis_data_WI`, `nwis_data_MN`, and `nwis_data_MI` again even though there was no need to download those files again. This happened because those three targets each depend on `oldest_active_sites`, the inventory target, and that target changed to include information about a gage in Illinois. As I noted in that issue, it would be ideal if each task branch only depended on exactly the values that determine whether the data need to be downloaded again. But we need a new tool to get there: a **splitter**.

The splitter we're going to create in this issue will split `oldest_active_sites` into a separate table for each state. In this case each table will be just one row long, but there are plenty of situations where the inputs to a set of tasks will be larger, even after splitting into task-size chunks. Some splitters will be quick to run and others will take a while, but either way, we'll be saving ourselves time in the overall pipeline!

### Background

#### The slow way to split

In general, **targets** best practices require that each `command` creates exactly one output, either an R object or a file. To follow this policy, we *could* write a function that would take the full inventory and one state name and return a one-row table.
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
...this works but means that `get_state_inventory()` is called for each of our task targets. Suppose that `sites_info` was a file that took a long time to read in - we've encountered cases like this for large spatial data files, for example - you'd have to re-open the file for each and every call to `get_state_inventory()`, which would be excruciatingly slow for a many-state pipeline.

Fortunately, there's another way.

#### The fast way to split

Instead of calling `get_state_inventory()` once for each state, we'll go ahead and write a single **splitter** function that accepts `oldest_active_sites` and creates a single-row table for each state. It will be faster to run because there will not be redundant reloading of the data to split. 

#### Your mission

In this issue you'll create a splitter to make your task table more efficient in the face of a changing inventory in `oldest_active_sites`. Your splitter function will generate separate one-row inventory data for each state.

Ready?
