You're getting close! The last step for this second combiner is to connect it to the main pipeline. But this isn't trivial, because right now your code in `do_state_tasks` creates the `obs_tallies` target in the main pipeline, and we'd like to keep that `obs_tallies` information. How do we get the results of both combiners into the main pipeline all at once?

### One function, two outputs?

To connect both combiners to the main pipeline - and more broadly to follow pipelining best practices, ensuring that our pipeline's reproducibility is robust to modification - we need `do_state_tasks()` to create a single target that represents all the effects of the task table that we want to be visible to the pipeline.

Let's take a moment to decide *which* effects of the task table we want to be visible. For this we need to check our project plans, because what we want does differ by project...ahh, here they are: In this course project we won't ever need to revisit the state-specific data tables again, so we don't need to carry those `WI_data`, `WI_tally`, etc. objects back to the main pipeline. The `obs_tallies` argument will be sufficient to store the state tallies, and the *timeseries_plots.yml* file is sufficient to represent the status of the plot .png files.

Great! So we only have two outputs that need to be represented by `state_tasks`: the big tallies table and the plot summary file. Unfortunately, two outputs is still one too many. How can we tell the main pipeline about these two objects using just one output?

This challenge should be ringing bells for you, because we've actually solved it twice already.
* The first time was with the inventory splitter, where we split the inventory but also created a summary file of the split-up inventory files.
* The second time was with the plot file combiner. Our *apply* operation had created one plot per state, but that's not easy to use downstream, so we then summarized those functions into *3_visualize/out/timeseries_plots.yml*.
In both cases, we had one function and many outputs...and we saved the day by creating a single summary output. So let's do that once more!

There are actually a few ways to implement this general strategy. So far we've created summary *files*, but in this case, the output of `do_state_tasks()` could be...
1. A faithful representation of the combiner targets as they were produced by *123_state_tasks.yml*: A list that contains (1) the contents of the tallies table and (2) a filename and hash describing the plot summary file (yes, that's a summary of a summary file).
2. A concise representation of the combiner targets: A list that contains a filename and hash for a tallies table file (in this case we'd write out that table to file) and for the plot summary file.
3. A ready-to-go translation of the combiner targets into R objects: A list that contains (1) the contents of the tallies table and (2) the contents of the plot summary file (in this case we'd read in the plot summary file as an r **yaml** object).
4. A file that could be shared with others: A file, perhaps in RDS format, that contains any of the above three options.

### :keyboard: Activity: Make a multi-output target

For this course, let's go with option 3 from the list above. 

- [ ] Add a new expression in `do_state_tasks()` right after
  ```r
  scmake('timeseries_plots.yml_promise', remake_file='123_state_tasks.yml')`
  ```
  to read *timeseries_plots.yml* into a tibble format:
  ```r
  timeseries_plots_info <- yaml::yaml.load_file('3_visualize/out/timeseries_plots.yml') %>%
    tibble::enframe(name = 'filename', value = 'hash') %>%
    mutate(hash = purrr::map_chr(hash, `[[`, 1))
  ```

- [ ] Change the return value of `do_state_tasks()` to be a list of both the tallies table and the plot summary tibble:
  ```r
  # Return the combiner targets to the parent remake file
  return(list(obs_tallies=obs_tallies, timeseries_plots_info=timeseries_plots_info))
  ```

- [ ] In *remake.yml*, change the target name for the result of `do_state_tasks()` from `obs_tallies` to `state_combiners`.

- [ ] Add these two unpacker targets right after the `state_combiners` target (`pluck()` is from **purrr**, which is loaded when you install the already-declared **tidyverse** package):
  ```r
  obs_tallies:
    command: pluck(state_combiners, target_name)
  timeseries_plots_info:
    command: pluck(state_combiners, target_name)
  ```
  
#### Test

- [ ] Run `obs_tallies <- scmake('obs_tallies')` and check the value of `obs_tallies`. Look good?

- [ ] Run `timeseries_plots_info <- scmake('timeseries_plots_info')` and check the value of `timeseries_plots_info`. Look good?

Add any comments, questions, or revelations to a comment on this issue.

<hr><h3 align="center">I'll respond when I see your comment.</h3>
