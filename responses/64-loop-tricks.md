That temperature data build should have worked pretty darn smoothly, with fault tolerance for those data pulls with simulated unreliability, a rebuild of everything that needed a rebuild, and console messages to inform you of progress through the pipeline. Yay!

I'll just share a few additional thoughts and then we'll wrap up. 

#### Ruminations and tricks

**Orphaned task-step files:** You might have been disappointed to note that there's still a **timeseries_VT.png** hanging out in the repository even though VT is now excluded from the inventory and the summary maps. Worse still, that file shows *discharge* data! There's no way to use **scipiper** to discover and remove such orphaned artifacts of previous builds, because with the new *123_state_tasks.yml*, **scipiper** doesn't even know that this file exists. So it's a weakness of these pipelines that you may want to bear in mind, though this particular weakness has never caused big problems for us. Still, to avoid or fix it, you could:
1. After building everything, sort the contents of *3_visualize/out* by datestamp and manually remove the files older than your switch to `parameter='00010'`.
2. Before you ever went to build the temperature version, you could have deleted all the files in the *out* folders. Then the new output files would get written into fresh, empty folders.
3. In addition to (2), you could also have completely deleted the *.remake* folder in your repository. This folder stores build status information and the actual contents of the R objects built in your pipeline, so this approach would also get rid of `VT_data` and `VT_tally` (which are otherwise just hidden dead weight in your project). 

**Disappearing fault tolerance:** With older versions of **scipiper** (before version 0.0.20), a major rebuild of a task table, such as the transition to temperature that you just completed, would likely have lacked fault tolerance. `loop_tasks()` would often have jumped straight over the loop attempts and into the final check for completeness (which doesn't provide fault tolerance). I changed that behavior while writing this course, so we don't need to worry about this anymore.

**Forcing rebuilds of task tables:** One trick I thought I'd be sharing in this course is the use of the `loop_tasks()` argument `force=TRUE`, which forces a rebuild of all task-step elements. This can seem necessary when, for example, your pipeline detects that `state_combiners` should be rebuilt but can't identify any task-steps that are out of date relative to their declared dependencies. We've used this argument a lot in the past, so here's how you could force a rebuild of all the task-steps in *123_state_tasks.yml* if you wanted:
* In `do_state_tasks()`, edit the `loop_tasks()` call to include `force=TRUE`
* Call `scmake('state_combiners', force=TRUE)`
* Remember: that's two `force`s! We've often forgotten this in the past.

OK, so now you know how to use `force=TRUE`. But as we covered earlier in this course, the best use of `force=TRUE` is as a temporary bandaid or diagnostic tool rather than as a permanent part of your pipeline, and after writing this course I can no longer think of a situation where it's truly necessary. Here are some examples of where you might be tempted but really should use a more permanent fix:
* You've become convinced that the data you were getting from NWIS were corrupted, and you want to force a complete redo of the downloads from that service. You could use `force=TRUE` for this, but in these pipelines courses we've also introduced you to the idea of a `dummy` argument to data-downloading functions that you can manually edit to trigger a rebuild. This is especially handy if you use the current datetime as the contents of that dummy variable, because then you have a git-committed record of when you last pulled the data. In our example project you might want a dummy variable that's shared between the inventory data pull and the calls to `get_site_data()`.
* You've made a change to the plotting function but the site plots just aren't rebuilding. Sure, you could make the same changes suggested above to force a rebuild, but better would be to declare the dependency on the plot function file (as a function argument to `do_state_tasks()` in *remake.yml* and as a `source` in *123_state_tasks.yml*).

**Fetching results from the *scipiper* database:** We've already used the `remake::fetch()` function in this course, but I want to share it again here to help you remember. It's just so handy! To access the current value of an R object in your main pipeline, just call
```r
oldest_active_sites <- remake::fetch('oldest_active_sites', remake_file='remake.yml')
```
or for fetching from a task table,
```r
AL_tally <- remake::fetch('AL_tally', remake_file='123_state_tasks.yml')
```
The nice thing about this function is that it doesn't take time to rebuild or even check the currentness of a target. It just loads and passes the object to you.

#### Make a pull request

Phew, what a lot you've learned in this course! Let's get your work onto GitHub.

- [ ] Commit your code changes for the temperature analysis, remembering to commit to the new branch ("{{ second-branch }}"). Push your changes to GitHub. You won't make a PR for this branch - it can just live on as an alternative to the "master" branch that documents the changes needed to analyze temperature instead of discharge.

- [ ] Create a PR to merge the "{{ first-branch }}" branch into "master". In the PR description, post your favorite figure produced during the course and any other observations you want to share.

<hr><h3 align="center">I'll respond when I see your PR.</h3>
