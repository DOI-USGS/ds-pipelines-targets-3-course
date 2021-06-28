That temperature data build should have worked pretty darn smoothly, with fault tolerance for those data pulls with simulated unreliability, a rebuild of everything that needed a rebuild, and console messages to inform you of progress through the pipeline. Yay!

I'll just share a few additional thoughts and then we'll wrap up. 

#### Ruminations and tricks

**Orphaned task-step files:** You might have been disappointed to note that there's still a **timeseries_VT.png** hanging out in the repository even though VT is now excluded from the inventory and the summary maps. Worse still, that file shows *discharge* data! There's no way to use **targets** to discover and remove such orphaned artifacts of previous builds, because this is a file not connected to the new pipeline and **targets** doesn't even know that it exists. So it's a weakness of these pipelines that you may want to bear in mind, though this particular weakness has never caused big problems for us. Still, to avoid or fix it, you could:
1. After building everything, sort the contents of *3_visualize/out* by datestamp and manually remove the files older than your switch to `parameter='00010'`.
2. Before you ever went to build the temperature version, you could have deleted all the files in the *out* folders. Then the new output files would get written into fresh, empty folders.

**Forcing rebuilds of targets:** One trick I thought I'd be sharing more of in this course is the use of the `tar_invalidate()`, which forces a rebuild of specified targets. This can seem necessary when you know that there has been a change but the pipeline is not detecting it. We've used this forced rebuild approach a lot in the past, but I can no longer think of a situation where it's truly necessary. The best use of `tar_invalidate()` is as a temporary bandaid or diagnostic tool rather than as a permanent part of your pipeline. Instead of forcing something to rebuild, you should determine the root cause of it being skipped and make sure pipeline is appropriately set up.

The one example where it may really feel necessary is when you want to force a complete redo of downloads from a web service. You could use `tar_invalidate()` for this, but in these pipelines courses we've also introduced you to the idea of a `dummy` argument to data-downloading functions that you can manually edit to trigger a rebuild. This is especially handy if you use the current datetime as the contents of that dummy variable, because then you have a git-committed record of when you last pulled the data. In our example project you might want a dummy variable that's shared between the inventory data pull and the calls to `get_site_data()`.

**Fetching results from the *targets* database:** We've already used these functions in this course, but I want to share them again here to help you remember. They're just so handy! To access the current value of a target from your pipeline, just call
```r
tar_load('oldest_active_sites')
```
or for fetching a file target,
```r
summary_state_timeseries <- readr::read_csv(tar_read('summary_state_timeseries_csv'))
```
The nice thing about these functions are that they don't take time to rebuild or even check the currentness of a target. It just loads or passes the object to you.

#### Make a pull request

Phew, what a lot you've learned in this course! Let's get your work onto GitHub.

- [ ] Commit your code changes for the temperature analysis, remembering to commit to the new branch ("{{ second-branch }}"). Push your changes to GitHub. You won't make a PR for this branch - it can just live on as an alternative to the "main" branch that documents the changes needed to analyze temperature instead of discharge.

- [ ] Create a PR to merge the "{{ first-branch }}" branch into "main". In the PR description, post your favorite figure produced during the course and any other observations you want to share.

<hr><h3 align="center">I'll respond when I see your PR.</h3>
