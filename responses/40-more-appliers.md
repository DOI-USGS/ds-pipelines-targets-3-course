Your pipeline is looking pretty good! Now it's time to add complexity. I've just added these two files to the repository:
* *2_process/src/tally_site_obs.R*
* *3_visualize/src/plot_site_data.R*

In this issue you'll add these functions to the branching code in the form of two new steps.

### Background

The goal of this issue is to expose you to **multi-step branching**. They're not hugely different from the single-step branching we've already implemented, but there are a few details that you haven't seen yet. The changes you'll make for this issue will also set us up to touch on some miscellaneous pipeline topics. Briefly, we'll cover:

* The syntax for adding multiple steps
* How to declare dependencies among steps within branching
* A quick look at / review of *split-apply-combine* with the lightweight **dplyr** syntax

#### Reminder about dynamic vs static branching

Remember that both dynamic and static branching can have multiple steps or **appliers**, but they are defined differently. We will focus on static branching for now, but remember that you can always reference the information for dynamic and static branching in their respective locations in the **targets** user guide ([dynamic branching documentation](https://books.ropensci.org/targets/dynamic.html); [static branching documentation](https://books.ropensci.org/targets/static.html)).

#### Adding another step in static branching

As you already know, static branching is set up using the `tar_map()` function, where task targets are defined by the argument `values` as either a list or data.frame and steps are defined by a call to `tar_target()` as an additional argument. Up until now, your static branching code in `_targets.R`, looks something like 

```r
tar_map(
  values = tibble(state_abb = states),
  tar_target(nwis_inventory, filter(oldest_active_sites, state_cd == state_abb)),
  tar_target(nwis_data, get_site_data(nwis_inventory, state_abb, parameter))
  # Insert step for tallying data here
  # Insert step for plotting data here
)
```

We actually already have more than one step in our branching setup - `nwis_inventory` and `nwis_data`. This shows that you can include additional calls to `tar_target()` to add more appliers to your branches. If you want to use a previous step's output, just use the target name from that step and **targets** will appropriately pass only the output relevant to each task target between the steps within `tar_map()`. We are going to add a few more steps to our static branching and there is already a hint for where we will add these ... *ahem* `#Insert step for tallying data here` and `#Insert step for plotting data here` *ahem*. 

#### Steps that require additional info per task

So far, we have used functions in static branching that only needed our state abbreviation, e.g. "WI" or "IL". What happens when we want to have other information used per task? For example, we need to save files per task and we want those to be passed into our step function. Easy! We can just edit the information we pass in for `values`. Currently, we are using a single-column `tibble` but that can easily have multiple columns and those columns can be used as arguments to `tar_target()` commands within `tar_map()`. We will try this out next!
