### :keyboard: Activity: Connect your splitter to the pipeline

You have a fancy new splitter, but you still need to connect it to the pipeline.

- [ ] Insert a call to `split_inventory()` as the very first code line within your `do_state_tasks()` function. Fill in the arguments, hard coding the `summary_file` and making use of the presence of `oldest_active_sites` within the local environment (it's already passed as an argument to `do_state_tasks()`). 
  _Note: In real pipelines, there might be some occasions when it makes more sense to define the splitter and its output as a separate target in the main pipeline (`remake.yml` in our case). This can be useful if the splitter takes a long time to run, and you don't want to rerun it every time you need to build or rebuild any of the task-steps within your task table. An extra target means a little more complexity to the pipeline, which is why we're not taking this path in this course example...but in some future pipeline you may well find it worth the complexity._

- [ ] Edit the `get_site_data()` function to expect a file rather than the all-states inventory and a state name. This will involve changing the argument list to `function(state_info_file, parameter)` and changing the first line of `get_site_data()` from a `filter()` call to a `readr::read_tsv()` call. To avoid a bunch of unnecessary messages gumming up your console output, include `col_types='cccddcDDi'` as the second argument in your call to `read_tsv()`.

- [ ] Back in *123_state_tasks.R*, edit the `command` for `download_step` so that it calls `get_site_data()` with the new arguments. Use `sprintf()` or another string-manipulation function to build the `state_info_file` argument.

#### Test

How did you do?

- [ ] Call `scmake()` and see what happens. Did you see the rebuilds and non-rebuilds that you expected?

- [ ] Add Indiana (`IN`) and Iowa (`IA`) to the vector of `states` in *remake.yml*. Rebuild. Did you see the rebuilds and non-rebuilds that you expected?

(If you're not sure what you should have expected, check with your course contact, or another teammate.)

#### Commit and PR

Comfortable with your pipeline's behavior? Time for a PR!

- [ ] Add `1_fetch/tmp/*` to your *.gitignore* file - no need to commit all those teeny state inventory files.

- [ ] Add `!1_fetch/tmp/state_splits.yml` to your *.gitignore* file to tell git that it should commit this one file even though it's in *1_fetch/tmp*. (You could have actually dealt with all files in *1_fetch/tmp* with just one .gitignore line, `1_fetch/tmp/*.tsv`...but I wanted you to know about `!` in *.gitignore* in case that's new to you. Neat, right?)

- [ ] Commit *1_fetch/tmp/state_splits.yml* and your changes to *123_state_tasks.R*, *1_fetch/src/get_site_data.R*, *123_state_tasks.yml*, *remake.yml*, and *.gitignore*. Use `git push` to push your change up to the "splitter" branch on GitHub.

When everything is committed and pushed, create a pull request on GitHub. In your PR description note which files got built when you added `IN` and `IA` to `states`.

<hr><h3 align="center">I'll respond on your new PR once I spot it.</h3>
