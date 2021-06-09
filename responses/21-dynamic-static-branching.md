Before we get to editing, let's briefly discuss the differences between static and dynamic branching, and how you choose between them.

### Dynamic branching

In dynamic branching, your **tasks** are defined by another target in your pipeline. They are *dynamic* because the task targets can change while the pipeline is being built. This is particular useful when the tasks depend on some number of files that may change through time as you run your pipeline. Read more about the key parts of dynamic branching below.

1. **Set up**: Dynamic branching is set up by using `tar_target()` as you usually would (where the `command` you pass in represents one **step**) but adding the argument `pattern` to define how to split a previous target into tasks. Typically, you will see `map()` used to define the `pattern` for splitting up a target into tasks, but you can find details about other options available [here in the `targets` documentation](https://books.ropensci.org/targets/dynamic.html#pattern-construction). 
2. **Define multiple steps**: To apply multiple steps to a set of tasks, you will need to write addition calls to `tar_target()` calls with `pattern` specified.
3. **Combining branch output**: To complete our split-apply-combine paradigm, we would need the output from each of our branches to be combined into one result per step. Dynamic branching will automatically **combine** the branches into a single output target for the branching step.
4. **Validation/testing**: For dynamic branching, you can test whether your branches are set up how you want them to be by using `tar_pattern()` and iterate on your branching structure before actually executing the pipeline.

Building on the example introduced previously, where we need to download, tally, and then plot data for multiple states, here is what dynamic branching could look like:

```r
library(targets)
library(tidyverse)
library(tarchetypes)

# Add source calls to files containing `get_nwis_data()`, `tally()`, and `plot()` here

list(
  tar_target(states, c('WI', 'MN', 'MI')),
  tar_target(data, get_nwis_data(states), pattern = map(states)),
  tar_target(count, tally(data), pattern = map(data)),
  tar_target(fig, plot(count), pattern = map(count))
)
```

### Static branching:

In static branching, your **tasks** are defined by a named list or data.frame passed into your branching command. This is *static* because the tasks created won't update with the pipeline. You would need to update the list or data.frame. Read more about the key parts of static branching below.

1. **Set up**: Static branching is set up by using `tar_map()` function from the package `tarchetypes`. First, you pass in your **tasks** as a named list or data.frame into the `values` argument. Then, you can set up a step by adding a call to `tar_target()` and using the column or list element name containing the unique tasks as an argument to your `command` function. 
2. **Define multiple steps**: To apply multiple steps to a set of tasks, pass additional calls to `tar_target()` as arguments to `tar_map()`. 
3. **Combining branch output**: To complete our split-apply-combine paradigm, we would need the output from each of our branches to be combined into one result per step. Static branching does not automatically **combine** the branches into a single output target for the branching step. After `tar_map()`, add a target for `tar_combine()`, where you pass in the output from `tar_map()` and then specify the command used to combine the results into one object.
4. **Validation/testing**: For static branching, you can test whether your branches are set up how you want them to be by using `tar_visnetowrk()`, as we have done to inspect our pipelines without branching. Once you are happy with your branching set up, you can execute the pipeline.

Going back once again to the pipeline where we need to download, tally, and then plot data for multiple states, here is what the static branching version would look like:

```r
library(targets)
library(tidyverse)
library(tarchetypes)

# Add source calls to files containing `get_nwis_data()`, `tally()`, and `plot()` here

tasks <- tibble(states = c('WI', 'MN', 'MI'))

list(
  tar_map(
    values = tasks,
    tar_target(data, get_nwis_data(states)),
    tar_target(count, tally(data)),
    tar_target(fig, plot(count))
  )
)
```

### How do you choose?

How do you know when to use dynamic or static branching? This is tricky because both will work in many scenarios (as we saw above), but it ultimately comes down to how your tasks are defined. 

When your tasks are predefined (e.g. states, a few basins, a specific set of user-defined sites), it makes sense to use static branching (though you can use dynamic as illustrated with our examples above). This doesn't mean you can't manually add a few additional tasks (e.g. include more states) but it means that adding more is a manual step that the user needs to remember to do. One pro to using static branching in these instances is that you can visualize your branches with the rest of your pipeline using `tar_visnetwork()`, whereas you cannot visualize the branches when using the dynamic branching approach.

When your tasks could change based on previous parts of your pipeline, you should choose dynamic branching. Examples of this include iterating over files in a directory (the files could change!) or using an inventory of sites to then pull data (when the inventory reruns, it may return different sites). A con is not being able to visualize your branches ahead of time, but you can still inspect them by running `tar_pattern()`. A pro with dynamic branching is that it follows the same pattern as all of your other targets, by using `tar_target()` with just one additional argument specified. Another pro for dynamic branching is that your output from each branch is automatically combined into one target. 

.............

With that intro out of the way, let's get going on *implementing* code for branching already!

<hr><h3 align="center">Add a comment to this issue to proceed.</h3>
