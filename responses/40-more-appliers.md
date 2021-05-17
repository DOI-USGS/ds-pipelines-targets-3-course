Your pipeline is looking pretty good! Now it's time to add complexity. I've just added these two files to the repository:
* *2_process/src/tally_site_obs.R*
* *3_visualize/src/plot_site_data.R*

In this issue you'll add these functions to the task table in the form of two new steps.

### Background

The goal of this issue is to expose you to **multi-step task tables**. They're not hugely different from the single-step task table we've already implemented, but there are a few details that you haven't seen yet. The changes you'll make for this issue will also set us up to touch on some miscellaneous pipeline topics. Briefly, we'll cover:

* The syntax for adding two steps to a task table
* How to declare dependencies among steps within a task table
* A quick look at / review of *split-apply-combine* with the lightweight **dplyr** syntax
* Uses and abuses of the `force = TRUE` argument to `scmake()` in the task-table context

#### Digging deeper into `create_task_step()`

The `create_task_step()` function offers a lot of flexibility if you're willing to figure out the syntax. Specifically, you might have noticed the `...` in the arguments list of each function you pass to `create_task_step()`. You don't get to decide what's available in the `...`s, but you do get do decide whether you use that information.

So far, the only named argument you've likely used is `task_name`, but other named arguments are passed in to the `target_name` and `command` functions when the task step is turned into a task plan with `create_task_plan()`. These other arguments allow you to look to other information about this task-step or previous steps within the task.

* If you're writing a `target_name`, you have access to the evaluated `step_name` for this task-step. Therefore, your function definition can be `function(...)` or `function(step_name, ...)` depending on whether you plan to use the step_name information or not. It'll get passed in regardless of whether you include that argument in the definition.
* If you're writing a `depends` function, you have access to the evaluated `target_name` and `step_name`. Therefore, your function definition can be either of these: `function(target_name, ...)`, `function(target_name, step_name, ...)`
* If you're writing a `command` function, you have access to the evaluated `target_name`, `step_name`, and `depends`. Therefore, your function definition can be any of these: `function(target_name, ...)`, `function(target_name, step_name, ...)`, or `function(target_name, step_name, depends, ...)`
* You can also get the evaluated values of `step_name`, `target_name`, `depends`, or `command` for any of the preceding steps for this task; all of these are available elements of the `steps` argument, which is a list named `steps`. Therefore, your function definition can be any of these: `function(steps, ...)`, `function(target_name, steps, ...)`, `function(target_name, step_name, steps, ...)`, or `function(target_name, step_name, depends, steps, ...)`. This is most useful if you're defining the 2nd, 3rd, etc. step, because then there's information to look back at. For example, if step 2 uses the target from step 1 as input, and if step 1 is named "prepare", then your definition for step 2 might look something like this:
```
step2 <- create_task_step(
  step_name = 'plot',
  target_name = function(target_name, ...) {
    sprintf("out/%s.png", target_name)
  },
  command = function(steps, ...) {
    sprintf('visualize(\'%s\', target_name)', steps[['prepare']]$target_name)
  }
)
```

You can always reference this information in the [task steps vignette](https://usgs-r.github.io/scipiper/task_plans.html) when you're working on real-world pipelines.
