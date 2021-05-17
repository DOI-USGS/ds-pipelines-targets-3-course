#### Check your progress

Here are my answers to the above questions:

_Q: 2. Add `'IL'` to the `states` target. Then call `scmake()` again. It builds `IL_data` for you right? Cool! But there's something inefficient happening here, too - what is it?_

A: It built `WI_data`, `MN_data`, and `MI_data` again even though there was no need to download those files again. This happened because those three targets each depend on `oldest_active_sites`, the inventory object, and that object changed to include information about a gage in Illinois. It would be ideal if each task target only depended on exactly the values that determine whether the data need to be downloaded again.

_Q: 3. Make a small change to the `get_site_data()` function: change `Sys.sleep(2)` to `Sys.sleep(0.5)`. Then call `scmake()` again. What's wrong with the output you see? Can you guess why this is happening?_

A: It didn't rebuild anything, even though the `get_site_data()` function changed. The change we made doesn't actually change the output files from this function, but **scipiper** doesn't know that; it should have rebuild all of the `_data` targerts. This happened because `scmake()` looks to *remake.yml* by default, and at that level, there's no indication that the `state_tasks` target depends on the definition of the `get_site_data()` function.

We'll solve the problem with (3) here and will deal with (2) in the next issue.

### :keyboard: Activity: Declare all the dependencies

To ensure that a task-table target like `state_tasks` always rebuilds when there are changes to the dependencies of the targets in *123_state_tasks.yml*, we need to declare all of those dependencies within the `command` or `depends` field of the `state_tasks` target. Currently `oldest_active_sites` is the only dependency of the `XX_data` targets that is already declared (because it happens to also be needed to construct the task remakefile). Let's declare the rest.

- [ ] The undeclared dependency we've already identified is `get_site_data()`. We can't directly declare functions as dependencies, but we can get pretty close by declaring the source code file (*1_fetch/src/get_site_data.R*) as a dependency. Specifically, we can identify the code file as a dependency by including the filename as an argument to the `do_state_tasks()` function. Amend the declaration of the `do_state_tasks()` function to have a `...` argument: `do_state_tasks <- function(oldest_active_sites, ...)`. Then in *remake.yml*, add `'1_fetch/src/get_site_data.R'` as an unnamed argument in the call to `do_state_tasks()`.

- [ ] It would be ideal to also declare `parameter` as a dependency to `state_tasks`, because `parameter` is needed by each call to `get_site_data()`. It's not strictly necessary in this example because `oldest_active_sites` will almost certainly change if `parameter` changes...but oh, heck, go ahead an add it anyway to build good habits. Rather than including `parameter` as an argument to the `do_state_tasks()` call, add it to the (new) `depends` field for the `state_tasks` target.

When you're satisfied with your code, commit your changes to existing R and YAML files, and also commit the new *123_state_tasks.yml* file.

We've gone both ways on committing *XYZ_tasks.yml* files (such as *123_state_tasks.yml*) in the past.
* Con to committing: These files are automatically generated, so it's not technically necessary to commit them.
* Pro: It's often convenient to commit them so they're visible to all teammates for discussion and debugging.
* Con: For large numbers of tasks, these files get to be so long that they're no longer easy to inspect using git or GitHub, so the benefits of committing them diminish.
* Pro: Even for large numbers of tasks, these YAML files are seldom too big to create actual problems with git.
Therefore, *our current team policy is to usually commit these auto-generated YAML files, with optional exceptions for really large task tables.*

Next, create a pull request with the final results of all the changes you've made for this issue.

<hr><h3 align="center">I'll respond when I see your PR.</h3>
