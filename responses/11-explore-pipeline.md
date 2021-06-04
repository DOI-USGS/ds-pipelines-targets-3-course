### :keyboard: Activity: Explore the starter pipeline

Without modifying any code, start by inspecting and running the existing data pipeline.

- [ ] Open up *_targets.R* and read through - can you guess what will happen when you build the pipeline?
- [ ] Build all targets in the pipeline.
- [ ] Check out the contents of `oldest_active_sites`.

:bulb: Refresher hints:

* To build a pipeline, run `library(targets)` and then `tar_make()`.
* To assign an R-object pipeline target to your local environment, run `tar_load(mytarget)`. This function will load the object in its current state. 
* If you want to make sure you have the most up-to-date version of the target, you can have **targets** check for currentness or rebuild first by running `tar_make(mytarget)` and then using `tar_load(mytarget)`.
* You'll pretty much always want to call `library(targets)` in your R session while developing pipeline code - otherwise, you need to call `targets::tar_make()` in place of `tar_make()` anytime you run that command, and all that extra typing can add up.

When you're satisfied that you understand the current pipeline, include the value of `oldest_active_sites$site_no` and the image from *site_map.png* in a comment on this issue.

<hr><h3 align="center">Add a comment to this issue to proceed.</h3>
