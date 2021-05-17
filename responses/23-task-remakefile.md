#### Check your progress

You should have seen this output when you ran `cat(scmake('state_tasks'))`:

```r
WI:
  task_name: WI
  steps:
    download:
      step_name: download
      target_name: WI_data
      depends: []
      command: get_site_data(sites_info=oldest_active_sites, state=I('WI'), parameter=parameter)
MN:
  task_name: MN
  steps:
    download:
      step_name: download
      target_name: MN_data
      depends: []
      command: get_site_data(sites_info=oldest_active_sites, state=I('MN'), parameter=parameter)
MI:
  task_name: MI
  steps:
    download:
      step_name: download
      target_name: MI_data
      depends: []
      command: get_site_data(sites_info=oldest_active_sites, state=I('MI'), parameter=parameter)
```

If you're not there yet, keep trying until your output matches mine. Then proceed: 

### :keyboard: Activity: Create the task remakefile

The final step in creating a task plan is to convert the R list task plan into a YAML file that **scipiper** can understand. To use the `create_task_makefile()` function in *123_state_tasks.R*,

- [ ] Replace this code chunk
```r
# Return test results to the parent remake file
return(yaml::as.yaml(task_plan))
```
with this one:
```r
# Create the task remakefile
create_task_makefile(
  # TODO: ADD ARGUMENTS HERE
  tickquote_combinee_objects = FALSE,
  finalize_funs = c())

# Return nothing to the parent remake file
return()
```

#### Refine the makefile

- [ ] Now modify the new block. Refer to the `?create_task_makefile` documentation to identify and use the right arguments to:

* Pass in the `task_plan`.

* Write out the remakefile to *123_state_tasks.yml*.

* Tell **scipiper** to connect the dependencies of targets in this remakefile to the targets in the main *remake.yml* file when executing the remakefile. Use the `include` argument for this purpose.

* Tell **scipiper** to load the R script that defines the `get_site_data()` function when executing the remakefile.

* Tell **scipiper** to load the packages needed to execute `get_site_data()` function when executing the remakefile.

* Leave `tickquote_combinee_objects = FALSE` and `finalize_funs = c()`. We'll explore these arguments later.

#### Test

Now we're `return`ing nothing from this function, because the current effect of this function is to create a file. If this were our end goal for this function, we would change the target in *remake.yml* to *123_state_tasks.yml*...but since we'll shortly change the file again, we won't bother. Just run `scmake('state_tasks')` to create the file.

And then check out your file! You should now see *123_state_tasks.yml* in the top-level directory. Open it; aside from some header comments and extra sections, you should recognize the format of the file as being similar to that of *remake.yml*. Refer to [this **remake** documentation page](https://github.com/richfitz/remake/blob/master/doc/format.md) for explanations of any sections you don't yet understand. There will also be one target in the new file that you did not define as a task step - do you understand the definition and utility of that target?

#### Explore

You now have a new remakefile. Put it through its paces to make sure it's working as expected and you understand why. Some things to try:

- [ ] Run `remake::diagram(remake_file='remake.yml')` and `remake::diagram(remake_file='123_state_tasks.yml')`. Do you understand the relationship between the two diagrams?

- [ ] Set the `include` argument to `c()` in `create_task_makefile()`, build the remakefile again with `scmake('state_tasks')`, and run `remake::diagram(remake_file='123_state_tasks.yml')`. Do you understand the resulting error? Set the `include` argument back to its original value once you're done experimenting.

- [ ] Run `scmake('WI_data', remake_file='123_state_tasks.yml')`, potentially revising your call to `create_task_makefile()` if needed, until you can get the target to build successfully. (Note that you can't just edit `123_state_tasks.R` and see the changes immediately reflected in `scmake('WI_data', remake_file='123_state_tasks.yml')` - you need to call `scmake('state_tasks')` after editing. This problem will go away once our task table function is fully connected to the main pipeline.)

- [ ] Run `scmake('123_state_tasks', remake_file='123_state_tasks.yml')` until you've downloaded data for all three states' gages.

When you're done exploring, paste the output of a successful call to `scmake('123_state_tasks', remake_file='123_state_tasks.yml')` into a new comment on this issue.

<hr><h3 align="center">I'll respond when I see your comment.</h3>
