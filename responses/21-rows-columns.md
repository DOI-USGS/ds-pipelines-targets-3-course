To get you started with coding, I've added a new file to the main branch (which you should have already pulled into your "{{ branch }}" branch) called *123_state_tasks.R*. This is the file where you'll write code to split a body of work into tasks, apply operations to each task, and combine the results back into end products.

### Design decisions

Before we get to editing, let's briefly discuss this file:

* Why an R script? Well, we've experimented with several ways of coding up task tables in past projects, and we've settled on a pattern where we wrap everything needed for a task table into a single R function (in this script) that can be called to generate a single target in the top-level *remake.yml*. The alternative would be to make separate **scipiper** targets for the task plan, the task makefile, and the task table output, but in practice this has turned out to be inconvenient, especially for team projects where we only want one person to run the tasks within a task table. You'll learn more about this in the "Shared-cache pipelines" course.

* Why "*123*"", and why isn't this file in a phase-specific *src* folder? Well, by the end of this course, we'll be doing data fetching, processing, and visualization steps for each state (the download, tally, and plot steps in the diagram at the top of this issue). Because we made the design decision to separate our workflow phases into *1_fetch*, *2_process*, and *3_visualize*, this task-table script crosses those three phases. Hence the "*123*", and hence the decision to keep this file at the top level rather than including it within just one of the three phases. Note that this isn't the only way we could have gone - we could have defined phases *1_inventory*, *2_statewise*, and *3_summarize* instead, then moved all the state-by-state code (including this file) into the second phase - but I didn't think "*statewise*" would be sufficiently clear to newcomers, and so here we are. This is the kind of pipelining decision we are frequently confronted with - choose wisely, but also enjoy the chance to be creative!

With that intro out of the way, let's get going on this task table already!

### :keyboard: Activity: Define your rows and columns

#### Connect to `remake.yml`

Connect this starter function to the *remake.yml* file. The function has well-formed (albeit boring) outputs already.

- [ ] Remember how last issue you added three targets beneath the line that said `# TODO: PULL SITE DATA HERE`? Well, now you should delete those targets and replace them with a recipe that calls the `do_state_tasks()` function.
```yml
  # TODO: PULL SITE DATA HERE
  state_tasks:
    command: do_state_tasks(oldest_active_sites)
```
- [ ] Remove those three `_data` targets from the `depends` list of the `main` target and replace them with `state_tasks`.

- [ ] Add "123_state_tasks.R" to the `sources` section of `remake.yml`.

- [ ] Add **scipiper** to the `packages` section of `remake.yml`, because shortly we'll be calling **scipiper** functions within pipeline recipes, including the recipe for `state_tasks`.

- [ ] Make sure the connection works by calling `print(scmake('state_tasks'))`. You should see 
```r
$example_target_name
[1] "WI_download"

$example_command
[1] "download(I('WI'))"
```
You can call this same command as you're revising code in the next couple of steps to check your progress.

#### Define the rows

Now modify *123_state_tasks.R* to define the rows of your task table.

- [ ] Define the rows by creating a vector of 2-digit state codes where it says `# TODO: DEFINE A VECTOR OF TASK NAMES HERE`. Use information from `oldest_active_sites`, which is already an argument to the `do_state_tasks()` function. You won't need much code.

#### Define the columns

Still in *123_state_tasks.R*, modify the existing column definition for `download_step` so that it pulls the data from NWIS for each state's oldest monitoring site, referring to `?create_task_step` for help on the syntax.

- [ ] Modify the `target_name` argument to `create_task_step()` so that each target (**task-step**) within this column will get a name like `WI_data`. The `target_name` argument should be a function of the form `function(task_name, step_name, ...) {}` where the body of the function constructs and returns a string for each combination of `task_name` (e.g., 'WI') and `step_name` (where we've already defined this step name to be 'download'). You can ignore the `step_name` this time. When it comes time to create the task plan (the R list), this function will get applied to each value of `task_name` in a vector of `task_names`.

- [ ] Modify the `command` argument to `create_task_step()` so that each command within this column will look like the commands you wrote for `wi_data`, `mn_data`, and `mi_data` in `remake.yml` in the previous issue. 

#### Test

When you're ready, call `print(scmake('state_tasks'))` and paste the output into a new comment on this issue.

<hr><h3 align="center">I'll respond when I see your comment.</h3>
