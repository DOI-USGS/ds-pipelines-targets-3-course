Great, you have a combiner hooked up from start to finish, and you probably learned some things along the way! It's time to add a second combiner that serves a different purpose - here, rather than produce a target that _contains_ the data of interest, we'll produce a combiner target that _summarizes_ the outputs of interest (in this case the state-specific .png files we've already created).

### Why do we need a summary target of outputs?

While this isn't necessary for the pipeline to operate, summarizing file output in large pipelines can be advantageous in some circumstances. Mainly, when we want to version control information about parts of the pipeline that were updated for ourselves or collaborators. We can't check in R object targets to GitHub and we usually avoid checking in data files (e.g. PNGs, CSVs, etc) to GitHub because of the file sizes. So, instead, we can combine some metadata about the file targets generated in the pipeline into a small text file and commit that to GitHub. Then, any future runs of the pipeline that change any of the metadata we include in the summary file would be tracked as a change to that file.

The first step is to write a custom function to take a number of target names and generate a summary file using output from `tar_meta()`. We will refer to this file as an indicator file, where the file lines *indicate* the hash of the file. We will save as a CSV so that individual lines of the CSV can be tracked as changed or not. See below for a function that does exactly this!

```r
summarize_targets <- function(ind_file, ...) {
  ind_tbl <- tar_meta(c(...)) %>% 
    select(tar_name = name, filepath = path, hash = data) %>% 
    mutate(filepath = unlist(filepath))
  
  readr::write_csv(ind_tbl, ind_file)
  return(ind_file)
}
```

### :keyboard: Activity: Add a summary combiner

#### Try this summary function

- [ ] Inspect the code within `summarize_targets()`

- [ ] Run the code to create `summarize_targets()` as a function in your local environment.

- [ ] Test it out with a command such as
  ```r
  summarize_targets('test.csv', site_map_png, oldest_active_sites)
  ```
  Check out the contents of *test.csv*. Then when you're feeling clear on what happened, delete *test.csv*.

#### Prepare the makefile to use `summarize_targets()`

- [ ] Copy/paste the `summarize_targets()` function to its own R script called `2_process/src/summarize_targets.R`.

- [ ] Add this new file to the pipeline by including a call to `source()` near the top of `_targets.R`.

- [ ] Add another target after `obs_tallies` to build this second combiner. The new line should be:
  ```r
  tar_combine(summary_state_timeseries_csv, state_branches, summarize_targets('3_visualize/out/summary_state_timeseries.csv', !!!.x), format="file")
  ```

- [ ] Run `tar_make()`. Inspect `'3_visualize/out/summary_state_timeseries.csv'`. Is that what you expect?

#### Test and revise `summary_state_timeseries_csv`

Hmm, you probably just discovered that *3_visualize/out/summary_state_timeseries.csv* used `summarize_targets()` for the `download`, `tally`, AND `plot` steps of the static branching. We could do that but what we really wanted to know was the metadata status for the plot file outputs only. 

- [ ] Adjust the input to `tar_combine()` for `summary_state_timeseries_csv` so that ONLY the third step of `state_branches` is being passed into the combiner function.

- [ ] Now run `tar_make()` again, and check out *3_visualize/out/summary_state_timeseries.csv* once more. Do you only have the PNG files showing up now?

When you're feeling confident, add a comment to this issue with the contents of *3_visualize/out/data_coverage.png* and *3_visualize/out/summary_state_timeseries.csv*.

<hr><h3 align="center">I'll respond when I see your comment.</h3>
