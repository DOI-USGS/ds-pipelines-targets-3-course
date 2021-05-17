#### Check your progress

You may have had to call `scmake('123_state_tasks', remake_file='123_state_tasks.yml')` a few times to get through any [pretend] failures in the data pulls, but ultimately you should have seen something like this output:

```r
> scmake('123_state_tasks', remake_file='123_state_tasks.yml')
Starting build at 2020-05-20 20:58:42
<  MAKE > 123_state_tasks
[    OK ] states
[    OK ] parameter
[    OK ] oldest_active_sites
[    OK ] WI_data
[    OK ] MN_data
[ BUILD ] MI_data                      |  MI_data <- get_site_data(sites_info = oldest_active_sites, state = "MI", ...
Retrieving data for site 04063522
[ ----- ] 123_state_tasks
Finished build at 2020-05-20 20:58:46
Build completed in 0.07 minutes
```

If you're not there yet, keep trying until your output matches mine. Then proceed: 

### :keyboard: Activity: Connect the task remakefile to remake.yml

Now that your function creates a complete and functional task remakefile, the remaining step is to revise the connection between the main *remake.yml* and the `do_state_tasks()` function: edit `do_state_tasks()` so that it not only creates but also builds the task remake file.

- [ ] Add these lines toward the end of `do_state_tasks()`, before the `return()` statement:
```r
# Build the tasks
scmake('123_state_tasks', remake_file='123_state_tasks.yml')
```
Wait, what?? You can call `scmake()` *within* a function that we're calling from a `remake.yml` target? Yep, sure can! It just works. (OK, mostly works - there's a gotchya we'll get into in the "Shared-cache pipelines" course, but it doesn't apply here.)

- [ ] Add `state_tasks` to the `depends` list for the `main` target in *remake.yml*.

That's it, you did it! For now, anyway.


#### Test

1. Call `scmake()` (with no arguments) until all data files have been downloaded.

2. Add `'IL'` to the `states` target. Then call `scmake()` again. It builds `IL_data` for you right? Cool! But there's something inefficient happening here, too - what is it? Can you guess why this is happening?

3. Make a small change to the `get_site_data()` function: change `Sys.sleep(2)` to `Sys.sleep(0.5)`. Then call `scmake()` again. What's wrong with the output you see? Can you guess why this is happening?

Answer the questions from 2 and 3 above in a new comment on this issue.

<hr><h3 align="center">I'll respond when I see your comment.</h3>
