### :keyboard: Activity: Explore the starter pipeline

Without modifying any code, start by inspecting and running the existing data pipeline.

- [ ] Open up *remake.yml* and read through - can you guess what will happen when you build the pipeline?
- [ ] Build all targets in the pipeline.
- [ ] Check out the contents of `oldest_active_sites`.

:bulb: Refresher hints:

* To build a pipeline, run `library(scipiper)` and then `scmake()`.
* To assign an R-object pipeline target to your local environment, run `mytarget <- scmake('mytarget')`. This function will check/build the object to make sure it's up-to-date before passing it to you. 
* If you don't want **scipiper** to check for currentness or rebuild first, run `mytarget <- remake::fetch('mytarget')`. This function is faster to run and can be handy for getting the old value of an object before you rebuild it.
* You'll pretty much always want to call `library(scipiper)` in your R session while developing pipeline code - otherwise, you need to call `scipiper::scmake()` in place of `scmake()` anytime you run that command, and all that extra typing can add up.

When you're satisfied that you understand the current pipeline, include the value of `oldest_active_sites$site_no` and the image from *site_map.png* in a comment on this issue.

<hr><h3 align="center">Add a comment to this issue to proceed.</h3>
