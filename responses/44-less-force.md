#### Check your progress

_Run `scmake()` to build the plots again. What happens? Do you know why?_

Nothing gets built! This is because the outer call to `scmake()` (from *remake.yml*) doesn't know that changes to `plot_site_data()` should trigger a rebuild of `state_tasks`.

_Run `scmake('state_tasks', force=TRUE)` to force the issue. What happens now? Why should you be uncomfortable with this solution?_

This approach does build the plots again. Once we persuade **scipiper** to rebuild `state_tasks`, the inner call to `scmake()` (within `do_state_tasks()`) is able to detect the change in `plot_site_data()` and recognizes the need to rebuild those plots. So we have a temporary solution...the problem is that this solution is not baked into the pipeline code, and you need to remember to run `scmake(..., force=TRUE)` just to achieve the primary assurance that a pipeline is supposed to provide - namely, that the outputs reflect the current code and data.

### When is it OK to force a build?

There's an option in `scmake()` to force the rebuild of one or more targets...but we're also discouraging its use. You saw a similar recommendation in the "Pipelines tips and tricks" course regarding depending on a directory: it's possible to use `force=TRUE` but better to use a `dummy` argument in that case. So when is it OK to use `force=TRUE`? Well, think of `force` as a first-aid kit - when you discover that something is not rebuilding when it should, you may want to try `force=TRUE` to ensure that you understand the situation and maybe even to produce the downstream targets quickly in a pinch. But the bandaid is not lasting, and you really ought to get that pipeline to an operating room as soon as you can to see if there's a more long-term solution such as declaring another dependency or adding a `dummy` argument.

### :keyboard: Activity: Avoid `force=TRUE`

You can avoid the need for `scmake(..., force=TRUE)` here by declaring the dependency on `plot_site_data.R` at the top level.

- [ ] Add `'3_visualize/src/plot_site_data.R'` as another unnamed argument in the recipe for `state_tasks` in *remake.yml*. 

- [ ] While you're in there, better do the same for `'2_process/src/tally_site_obs.R'` for the same reason! 

- [ ] Does this adding of source files feel familiar? You did it for *1_fetch/src/get_site_data.R* a few issues ago, but it's an easy step to forget. You can actually save yourself the headache altogether if you set up your code a bit differently. First, see how the contents of `...` in `do_state_tasks()` exactly match the contents of the `sources` argument to `create_task_makefile()`? This will be a consistent pattern, so rewrite that `create_task_makefile()` argument to use the `...`, like so: `sources = c(...)`. Now you only need to remember to add new source files for *123_state_tasks.yml* in one place - *remake.yml* - so it should be easier to get right.

Now that we've fixed that last issue, your code is ready for a pull request. Go for it!

<hr><h3 align="center">I'll respond when I see your PR.</h3>
