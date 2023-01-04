<details>
<summary><h2>Recognize the Unique Demands of Data-rich Pipelines</h2></summary>

In this course you'll learn about tools for data-intensive pipelines: how to download many datasets, run many models, or make many plots. Whereas a `for` loop would work for many quick tasks, here our focus is on tools for managing sets of larger tasks that each take a long time and/or are subject to occasional failure.

A recurring theme in this activity will be the *split-apply-combine* paradigm, which has many implementations in many software languages because it is so darn useful for data analyses. It works like this:

1. *Split* a large dataset or list of tasks into logical chunks, e.g., one data chunk per lake in an analysis of many lakes.
1. *Apply* an analysis to each chunk, e.g., fit a model to the data for each lake.
1. *Combine* the results into a single orderly bundle, e.g., a table of fitted model coefficients for all the lakes.

There can be variations on this basic paradigm, especially for larger projects:

1. The choice of how to *Split* an analysis can vary - for example, it might be fastest to download data for chunks of 100 sites rather than downloading all 10000 sites at once or downloading each site independently.
1. Sometimes we have several *Apply* steps - for example, for each site you might want to munge the data, fit a model, extract the model parameters, _and_ make a diagnostic plot specific to that site.
1. The *Combine* step isn't always necessary to the analysis - for example, we may prefer to publish a collection of plot .png files, one per site, rather than combining all the site plots into a single unweildy report file. That said, we may still find it useful to _also_ create a table summarizing which plots were created successfully and which were not.

### Setting Up Your Repo

You'll be revising files in this repository shortly. To follow a process similar to our team's standard git workflow, you should first clone this training repository to your local machine so that you can make file changes and commits there. 

### :keyboard: Activity: Set up your local repository

Open a git bash shell (Windows) or a terminal window (Mac) and change (`cd`) into the directory you work in for projects in R (for me, this is `~/Documents/Code`). There, clone the repository and set your working directory to the new project folder that was created:
```
git clone git@github.com:<user-name>/ds-pipelines-3-course-static.git
cd ds-pipelines-3-course-static
```

### :keyboard: Activity: Install packages as needed

You may need to install some of the packages for this course if you don't have them already. These are:

* **targets**
* **tarchetypes**
* **tidyverse**
* **dataRetrieval**
* **urbnmapr**
* **rnaturalearth**
* **cowplot**
* **leaflet**
* **leafpop**
* **htmlwidgets**

Install **urbnmapr** with `remotes::install_github('UrbanInstitute/urbnmapr')`.

All the rest should be installable with `install.packages()`.

### :keyboard: Activity: Invite some collaborators

One of the course coordinators was named as your contact for this course. They will provide code reviews during your course. To make it possible for you to request reviews from them, go to the *Settings* tab, *Manage access* subtab, and then click the green button to *Invite a collaborator* to add each of their usernames to your repo.

![How to invite reviewers](https://user-images.githubusercontent.com/12039957/83422503-9fb65e00-a3f7-11ea-8e06-ad87c813247e.png)

</details>

<hr>

<details>
<summary><h2>Meet the Example Problem</h2></summary>

It's time to meet the data analysis challenge for this course! Over the next series of lessons, you'll connect with the [USGS National Water Information System (NWIS)](https://waterdata.usgs.gov/nwis) web service to learn about some of the longest-running monitoring stations in USGS streamgaging history.

The repository for this course is already set up with a basic **targets** data pipeline that:
* Queries NWIS to find the oldest discharge gage in each of three Upper Midwest states
* Maps the state-winner gages

### :keyboard: Activity: Switch to a new branch

Before you edit any code, create a local branch called "three-states" and push that branch up to the remote location "origin" (which is the github host of your repository).

```
git checkout main
git pull origin main
git checkout -b three-states
git push -u origin three-states
```

The first two lines aren't strictly necessary when you don't have any new branches, but it's a good habit to head back to `main` and sync with "origin" whenever you're transitioning between branches and/or PRs.

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

When you're satisfied that you understand the current pipeline, note the value of `oldest_active_sites$site_no` and the image from *site_map.png* in an issue.

### :keyboard: Activity: Spot the split-apply-combine

Hey, did you notice that there's a *split-apply-combine* action happening in this repo already?

Check out the `find_oldest_sites()` function:
```r
find_oldest_sites <- function(states, parameter) {
  purrr::map_df(states, find_oldest_site, parameter)
}
```
This function:
- *splits* `states` into each individual state
- *applies* `find_oldest_site` to each state
- *combines* the results back into a single `tibble`

and it all happened in just one line! The *split-apply-combine* operations we'll be exploring in this course require more code and are more useful for slow or fault-prone activities, but they follow the same general pattern.

Check out the documentation for `map_df` at `?purrr::map_df` or [online here](https://purrr.tidyverse.org/reference/map.html) if this function is new to you.

### :keyboard: Activity: Apply a downloading function to each state

Awesome, time for your first code changes :pencil2:.

- [ ] Write three targets in *_targets.R* to apply `get_site_data()` to each state in `states` (insert these new targets under the `# TODO: PULL SITE DATA HERE` placeholder in `_targets.R`). The targets should be named `wi_data`, `mn_data`, and `mi_data`. `oldest_active_sites` should be used for the `sites_info` argument in `get_site_data()`.

- [ ] Add a call to `source()` near the top of *_targets.R* as needed to make your pipeline executable.

- [ ] Test it: You should be able to run `tar_make()` with no arguments to get everything built.

:bulb: Hint: the `get_site_data()` function already exists and shouldn't need modification. You can find it by browsing the repo or by hitting **Ctrl-SHIFT-F.** in RStudio and then searching for "get_site_data".

When you're satisfied with your code, open a PR to merge the "three-states" branch into "main". Make sure to add `_targets/*`, `3_visualize/out/*`, and any *.DS_Store* files to your `.gitignore` file before committing anything. In the description box for your PR, include a screenshot or transcript of your console session where the targets get built.

</details>

<hr>

<details>
<summary><h2>Make Targets for Oldest Gage Sites</h2></summary>

Congrats, your PR is open! 

Did you have to run `tar_make()` more than once to get the build to complete? I set up the repo so that would be likely. Note that you *didn't* have to change your code or figure out which targets failed before calling `tar_make()` again - that's the beauty of a formal data pipeline. But you *did* (probably) have to call `tar_make()` several times...that's the inefficiency that we'll be tackling in the next section. Stay tuned! :popcorn:

### :keyboard: Activity: Get this PR reviewed

You've probably coded things correctly to resolve the issues presented earlier...but to follow our best practices, you should still ask someone else to do a review and merge when they agree it's ready.

Assign your course contact to review and merge your PR (after any revisions that may be needed). Also add comments to this PR or in Teams with any questions that have come up.

</details>

<hr>

<details>
<summary><h2>Branching</h2></summary>

In the last section you noted some inefficiencies with writing out many nearly-identical targets within a remake.yml:
1. It's a pain (more typing and potentially a very long *_targets.R* file) to add new sites.
2. Potential for errors (more typing, more copy/paste = more room for making mistakes).

In this section we'll fix those inefficiencies by adopting the *branching* approach supported by **targets** and the support package **tarchetypes**.

### Definitions

**Branching** in **targets** refers to the approach of scaling up a pipeline to accomodate many tasks. It is the **targets** implementation of the *split-apply-combine* operation. In essence, we *split* a dataset into some number of **tasks**, then to each task we *apply* one or more analysis **steps**. Branches are the resulting targets for each unique task-and-step match.

In the example analysis for this course, each task is a state and the first step is a call to `get_site_data()` for that state's oldest monitoring site. Later we'll create additional steps for tallying and plotting observations for each state's site. See the image below for a conceptual model of branching for this course analysis.

![Branches](https://user-images.githubusercontent.com/13220910/125487324-fe9f0204-80ec-4d06-b751-ebf434eec64c.png)

We implement branching in two ways: as **static branching**, where the task targets are predefined before the pipeline runs, and **dynamic branching**, where task targets are defined while the pipeline runs.

In this section you'll adjust the existing pipelining to use branching for this analysis of USGS's oldest gages.

### :keyboard: Activity: Switch to a new branch

Before you edit any code, create a local branch called "static-branching" and push that branch up to the remote location "origin" (which is the github host of your repository).

```
git checkout main
git pull origin main
git checkout -b static-branching
git push -u origin static-branching
```

The first two lines aren't strictly necessary when you don't have any new branches, but it's a good habit to head back to `main` and sync with "origin" whenever you're transitioning between branches and/or PRs.
                   
<hr> 
  
Before we get to editing, let's briefly discuss the differences between static and dynamic branching, and how you choose between them.

### Dynamic branching

In dynamic branching, your **tasks** are defined by another target in your pipeline. They are *dynamic* because the task targets can change while the pipeline is being built. This is particular useful when the tasks depend on some number of files that may change through time as you run your pipeline. Read more about the key parts of dynamic branching below.

1. **Set up**: Dynamic branching is set up by using `tar_target()` as you usually would (where the `command` you pass in represents one **step**) but adding the argument `pattern` to define how to split a previous target into tasks. Typically, you will see `map()` used to define the `pattern` for splitting up a target into tasks, but you can find details about other options available [here in the `targets` documentation](https://books.ropensci.org/targets/dynamic.html#pattern-construction). 
2. **Define multiple steps**: To apply multiple steps to a set of tasks, you will need to write addition calls to `tar_target()` calls with `pattern` specified.
3. **Combining branch output**: To complete our split-apply-combine paradigm, we would need the output from each of our branches to be combined into one result per step. Dynamic branching will automatically **combine** the branches into a single output target for the branching step.
4. **Validation/testing**: For dynamic branching, you can test whether your branches are set up how you want them to be by using `tar_pattern()` and iterate on your branching structure before actually executing the pipeline.

Building on the example introduced previously, where we need to download, tally, and then plot data for multiple states, here is what dynamic branching could look like:

```r
library(targets)
library(tidyverse)
library(tarchetypes)

# Add source calls to files containing `get_nwis_data()`, `tally()`, and `plot()` here

list(
  tar_target(states, c('WI', 'MN', 'MI')),
  tar_target(data, get_nwis_data(states), pattern = map(states)),
  tar_target(count, tally(data), pattern = map(data)),
  tar_target(fig, plot(count), pattern = map(count))
)
```

### Static branching

In static branching, your **tasks** are defined by a named list or data.frame passed into your branching command. This is *static* because the tasks created won't update with the pipeline. You would need to update the list or data.frame. Read more about the key parts of static branching below.

1. **Set up**: Static branching is set up by using `tar_map()` function from the package `tarchetypes`. First, you pass in your **tasks** as a named list or data.frame into the `values` argument. Then, you can set up a step by adding a call to `tar_target()` and using the column or list element name containing the unique tasks as an argument to your `command` function. 
2. **Define multiple steps**: To apply multiple steps to a set of tasks, pass additional calls to `tar_target()` as arguments to `tar_map()`. 
3. **Combining branch output**: To complete our split-apply-combine paradigm, we would need the output from each of our branches to be combined into one result per step. Static branching does not automatically **combine** the branches into a single output target for the branching step. After `tar_map()`, add a target for `tar_combine()`, where you pass in the output from `tar_map()` and then specify the command used to combine the results into one object.
4. **Validation/testing**: For static branching, you can test whether your branches are set up how you want them to be by using `tar_visnetowrk()`, as we have done to inspect our pipelines without branching. Once you are happy with your branching set up, you can execute the pipeline.

Going back once again to the pipeline where we need to download, tally, and then plot data for multiple states, here is what the static branching version would look like:

```r
library(targets)
library(tidyverse)
library(tarchetypes)

# Add source calls to files containing `get_nwis_data()`, `tally()`, and `plot()` here

tasks <- tibble(states = c('WI', 'MN', 'MI'))

list(
  tar_map(
    values = tasks,
    tar_target(data, get_nwis_data(states)),
    tar_target(count, tally(data)),
    tar_target(fig, plot(count))
  )
)
```

### How do you choose?

How do you know when to use dynamic or static branching? This is tricky because both will work in many scenarios (as we saw above), but it ultimately comes down to how your tasks are defined. 

When your tasks are predefined (e.g. states, a few basins, a specific set of user-defined sites), it makes sense to use static branching (though you can use dynamic as illustrated with our examples above). This doesn't mean you can't manually add a few additional tasks (e.g. include more states) but it means that adding more is a manual step that the user needs to remember to do. One pro to using static branching in these instances is that you can visualize your branches with the rest of your pipeline using `tar_visnetwork()`, whereas you cannot visualize the branches when using the dynamic branching approach.

When your tasks could change based on previous parts of your pipeline, you should choose dynamic branching. Examples of this include iterating over files in a directory (the files could change!) or using an inventory of sites to then pull data (when the inventory reruns, it may return different sites). A con is not being able to visualize your branches ahead of time, but you can still inspect them by running `tar_pattern()`. A pro with dynamic branching is that it follows the same pattern as all of your other targets, by using `tar_target()` with just one additional argument specified. Another pro for dynamic branching is that your output from each branch is automatically combined into one target. 


With that intro out of the way, let's get going on *implementing* code for branching already!

<hr>

Now that you have learned about branching, let's add it to our code. Currently, you have 3 individual targets that will download site data from our 3 Midwest states and store in a target named with the state name. Those targets look something like this:

```r
tar_target(wi_data, get_site_data(oldest_active_sites, states[1], parameter)),
tar_target(mn_data, get_site_data(oldest_active_sites, states[2], parameter)),
tar_target(mi_data, get_site_data(oldest_active_sites, states[3], parameter)),
```

We are going to convert the code for those targets into static branching. We are going to make these changes on the branch that we created earlier. Let's get started!

### :keyboard: Activity: Implement static branching to download data by state

#### Include appropriate packages

Now that we are using static branching, our main pipeline makefile will need the `tarchetypes` package. In addition, we will use `tibble::tibble()` to define our task data.frame. Make these two packages available to the targets pipeline by adding the following to the other library calls in `_targets.R`:

```r
library(tarchetypes)
library(tibble)
```

#### Replace state targets with branching code

To get started, copy the code below and replace your 3 individual state targets (shown above) with it.

```r
tar_map(
  values = tibble(state_abb = states),
  tar_target(data, get_site_data(oldest_active_sites, state_abb, parameter))
  # Insert step for tallying data here
  # Insert step for plotting data here
),
```

#### Verify your task values

This is already set up for you, but is worth going over. Your task names are passed into `tar_map()` using the argument `values`. This argument will accept a list or a data.frame/tibble and the names of the list elements or columns are used as arguments to the functions in your steps. Rather than change the `states` object outside of `tar_map()` (because that would require us to also update `oldest_active_sites` which uses `states`), we are using that vector to create a column called `state_abb` in the `tibble` passed to `values`. That means, when we need to pass in the task names as an argument to a function, we use `state_abb`, the column name containing those task names.

#### Check your progress

You have already learned about `tar_visnetwork()` as a way to visualize your pipeline before running it. By default, it will show targets and functions. We would just like to check that our branch targets are set up appropriately, so try running `tar_visnetwork(targets_only = TRUE)` to get a visual with just targets. You should see something similar to the image below, where there are three targets prefixed with `data_`. 

![branch_targets](https://user-images.githubusercontent.com/13220910/119854642-daea5080-bed6-11eb-9c64-a4bfab5d437a.png)

Those targets prefixed with `data_` are the branches (targets per task-step) for the `get_site_data()` step. They are automatically named using the target name you pass to `tar_target()` + an `_` + the task identifier. You can test this by changing that target name from `data` to `nwis_data` and re-running `tar_visnetwork(targets_only = TRUE)`. You should now see the branches `nwis_data_MI`, `nwis_data_MN`, and `nwis_data_WI` in the visual.

You can also use a function called `tar_manifest()` to check your pipeline before running. It will return a table of information about each target and the function call that will be used to create it. Try running `tar_manifest()`. You should see

```r
# A tibble: 5 x 3
  name                command                                                            pattern
  <chr>               <chr>                                                              <chr>  
1 oldest_active_sites "find_oldest_sites(states, parameter)"                             NA     
2 nwis_data_MI        "get_site_data(oldest_active_sites, \"MI\", parameter)"            NA     
3 nwis_data_MN        "get_site_data(oldest_active_sites, \"MN\", parameter)"            NA     
4 nwis_data_WI        "get_site_data(oldest_active_sites, \"WI\", parameter)"            NA     
5 site_map_png        "map_sites(\"3_visualize/out/site_map.png\", oldest_active_sites)" NA        
```

If your pipeline doesn't look as you expect it should, keep iterating on your code in the `_targets.R` file. When you're happy with your pipeline, run `tar_manifest(starts_with('nwis_data'))` to see the details for just the branches.

<hr>

Now that you have branching set up for downloading data from NWIS, it is time to run the pipeline!

### :keyboard: Activity: Use `tar_make()` to build the pipeline with static branching

Run `tar_make()` to execute your pipeline. You may have to call `tar_make()` a few times to get through any [pretend] failures in the data pulls (I had to run it 5 times), but ultimately you should have seen something like this output:

```r
> tar_make()
v skip target oldest_active_sites
v skip target nwis_data_MI
v skip target nwis_data_MN
* run target nwis_data_WI
  Retrieving data for WI-04073500
* run target site_map_png
* end pipeline
```

If you're not there yet, keep trying until your output has only `*` or `v` next to the output. Then proceed: 

1. Call `tar_make()` one more time. You should see a green "V" next to each target.

2. Add `'IL'` to the `states` target. Then call `tar_make()` again (you may have to run it multiple times to get passed [pretend] failures). It builds `data_IL` for you right? Cool! But there's something inefficient happening here, too - what is it? Can you guess why this is happening?

3. Make a small change to the `get_site_data()` function: change `Sys.sleep(2)` to `Sys.sleep(0.5)`. Then call `tar_make()` again (and again and again if you get [pretend] internet failures). What happened?

Answer the questions from 2 and 3 above for yourself.

#### Check your progress

Here are my answers to the above questions:

_Q: 2. Add `'IL'` to the `states` target. Then call `tar_make()` again (you may have to run it multiple times to get passed [pretend] failures). It builds `data_IL` for you right? Cool! But there's something inefficient happening here, too - what is it? Can you guess why this is happening?_

A: It built `WI_data`, `MN_data`, and `MI_data` again even though there was no need to download those files again. This happened because those three targets each depend on `oldest_active_sites`, the inventory object, and that object changed to include information about a gage in Illinois. It would be ideal if each branch only depended on exactly the values that determine whether the data need to be downloaded again.

_Q: 3. Make a small change to the `get_site_data()` function: change `Sys.sleep(2)` to `Sys.sleep(0.5)`. Then call `tar_make()` again (and again and again if you get [pretend] internet failures). What happened?_

A: It skipped `oldest_active_sites` and then rebuilt each of the branches, `nwis_data_MI`, `nwis_data_MN`, `nwis_data_WI`, and `nwis_data_IL`. **targets** knows that the function updated and that these targets depend on that function. So cool! But the change we made doesn't actually change the output files from this function, but **targets** doesn't know that; it noticed a change in the function and rebuilt all of the targets that used it. The good thing is that any targets that depend on these `nwis_data_` targets would not rebuild because they wouldn't have changed since the last build. Also a reminder as to why it is a good idea to keep functions focused on smaller, specific activities. The more that the function does, the more opportunities there are for you to make updates/fixes/improvements, and you may end up rebuilding more than you want to. 

We'll deal with (2) in the next section.

### :keyboard: Activity: Create a PR with your new branching technique

You now have a functioning pipeline that uses branching to download data for the oldest USGS streamgage in 4 different states! Go ahead and commit these changes to `_targets.R` to your branch and then open a Pull Request. Now assign your course contact to review your PR. Either they or you can merge after any comments or change requests have been resolved.

</details>

<hr>

<details>
<summary><h2>Splitters</h2></summary>

In the last section you noted a lingering inefficiency: When you added Illinois to the `states` vector, your branching pipeline built `nwis_data_WI`, `nwis_data_MN`, and `nwis_data_MI` again even though there was no need to download those files again. This happened because those three targets each depend on `oldest_active_sites`, the inventory target, and that target changed to include information about a gage in Illinois. As I noted in that section, it would be ideal if each task branch only depended on exactly the values that determine whether the data need to be downloaded again. But we need a new tool to get there: a **splitter**.

The splitter we're going to create in this section will split `oldest_active_sites` into a separate table for each state. In this case each table will be just one row long, but there are plenty of situations where the inputs to a set of tasks will be larger, even after splitting into task-size chunks. Some splitters will be quick to run and others will take a while, but either way, we'll be saving ourselves time in the overall pipeline!

### Background

#### The object way to split

So far in our pipeline, we already have an object that contains the inventory information for all of the states, `oldest_active_sites`. Now, we can write a splitter to take the full inventory and one state name and return a one-row table.

```r
get_state_inventory <- function(sites_info, state) {
  site_info <- dplyr::filter(sites_info, state_cd == state)
}
```

And then we could insert an initial branching step where we pulled out that state's information before passing it to the next step, such that our `tar_map()` call would look like:
```r
tar_map(
  values = tibble(state_abb = states),
  tar_target(nwis_inventory, get_state_inventory(sites_info = oldest_active_sites, state_abb)),
  tar_target(nwis_data, get_site_data(nwis_inventory, state_abb, parameter))
)
```

#### The file way to split

The "object way to split" described above works well in many cases, but note that `get_state_inventory()` is called for each of our task targets (so each state). Suppose that `oldest_active_sites` was a file that took a long time to read in - we've encountered cases like this for large spatial data files, for example - you'd have to re-open the file for each and every call to `get_state_inventory()`, which would be excruciatingly slow for a many-state pipeline. If you find yourself in that situation, you can approach "splitting" with files rather than objects.

Instead of calling `get_state_inventory()` once for each state, we could and write a single **splitter** function that accepts `oldest_active_sites` and writes a single-row table for each state. It will be faster to run because there will not be redundant reloading of the data that is needing to be split. This type of splitter would not be within your branching code and instead return a single summary table describing the state-specific files that were just created. 

For this next exercise, the object method for splitting described before will suit our needs just fine. There is no need to create a single splitter function that saves state-specific files for now. We are mentioning it here so that you can be aware of the limitations of splitters and be aware that other options exist.

#### Your mission

In this section you'll create a splitter to make your task table more efficient in the face of a changing inventory in `oldest_active_sites`. Your splitter function will generate separate one-row inventory data for each state.

Ready?

<hr>

### :keyboard: Activity: Switch to a new branch

Before you edit any code, create a local branch called "splitter" and push that branch up to the remote location "origin" (which is the github host of your repository).

```
git checkout main
git pull origin main
git checkout -b splitter
git push -u origin splitter
```

The first two lines aren't strictly necessary when you don't have any new branches, but it's a good habit to head back to `main` and sync with "origin" whenever you're transitioning between branches and/or PRs.

<hr>

### :keyboard: Activity: Create a separate inventory for each state

- [ ] Add a new target to your `tar_map()` call just before the `nwis_data` target but below the `values` input using this boilerplate:
  ```r
  tar_target(nwis_inventory, ),
  ```

- [ ] Add code to subset the rows in `oldest_active_sites` based on the branching variable, `state_abb`. Remember that `oldest_active_sites` has a column called `state_cd` containing the state abbreviations. Hint: go peek at the first line of the function `get_site_data()` in `1_fetch/src/get_site_data.R`.

- [ ] Edit your call for the `nwis_data` target to use `nwis_inventory` instead of `oldest_active_sites` to take advantage of your newly split data.

- [ ] Lastly, the first step in `get_site_data()` that filters the input data is not longer needed (because that is taken care of in your new splitter step!). But careful - the incoming data is an argument called `sites_info` but the rest of the function relies on `site_info` (singular `site` not `sites`). So, delete that first line but then update the argument name to be singular, `site_info`. Now you are good :)

#### Test

When you think you've got it right, run your pipeline again!
```r
tar_make()
```

You should now see targets being built called `nwis_inventory_WI`, `nwis_inventory_IL`, etc. It should redownload all of the data for WI, MN, MI, and IL (so rebuild `nwis_data_WI`, `nwis_data_MI`, etc) because we changed the inputs and the function for those targets. The real magic comes next.

If you're not quite getting the build to work, keep editing until you have it (but remember that there may still be "internet transfer failures" which require you to run `tar_make()` a few times). When you've got it, copy and paste the console output of `tar_make()` and `tar_visnetwork()` into an issue.

<hr>

### :keyboard: Activity: Test your splitter's power

You have a fancy new splitter, but you still need to see the benefits in action.

#### Test

- [ ] Call `tar_make()` one more time. Nothing should rebuild.

- [ ] Add Indiana (`IN`) and Iowa (`IA`) to the vector of `states` in *_targets.R*. Rebuild. Did you see the rebuilds and non-rebuilds that you expected?

(If you're not sure what you should have expected, check with your course contact, or another teammate.)

#### Commit and PR

Comfortable with your pipeline's behavior? Time for a PR!

- [ ] Commit your changes to *1_fetch/src/get_site_data.R*, and *_targets.R*. Use `git push` to push your change up to the "splitter" branch on GitHub.

When everything is committed and pushed, create a pull request on GitHub. In your PR description note which targets got built when you added `IN` and `IA` to `states` and copy/paste the console output of `tar_make()` and `tar_visnetwork()`.

</details>

<hr>

<details>
<summary><h2>Appliers</h2></summary>

Your pipeline is looking pretty good! Now it's time to add complexity. I've just added these two files to the repository:
* *2_process/src/tally_site_obs.R*
* *3_visualize/src/plot_site_data.R*

In this section you'll add these functions to the branching code in the form of two new steps.

### Background

The goal of this section is to expose you to **multi-step branching**. They're not hugely different from the single-step branching we've already implemented, but there are a few details that you haven't seen yet. The changes you'll make for this section will also set us up to touch on some miscellaneous pipeline topics. Briefly, we'll cover:

* The syntax for adding multiple steps
* How to declare dependencies among steps within branching
* A quick look at / review of *split-apply-combine* with the lightweight **dplyr** syntax

#### Reminder about dynamic vs static branching

Remember that both dynamic and static branching can have multiple steps or **appliers**, but they are defined differently. We will focus on static branching for now, but remember that you can always reference the information for dynamic and static branching in their respective locations in the **targets** user guide ([dynamic branching documentation](https://books.ropensci.org/targets/dynamic.html); [static branching documentation](https://books.ropensci.org/targets/static.html)).

#### Adding another step in static branching

As you already know, static branching is set up using the `tar_map()` function, where task targets are defined by the argument `values` as either a list or data.frame and steps are defined by a call to `tar_target()` as an additional argument. Up until now, your static branching code in `_targets.R`, looks something like 

```r
tar_map(
  values = tibble(state_abb = states),
  tar_target(nwis_inventory, filter(oldest_active_sites, state_cd == state_abb)),
  tar_target(nwis_data, get_site_data(nwis_inventory, state_abb, parameter))
  # Insert step for tallying data here
  # Insert step for plotting data here
)
```

We actually already have more than one step in our branching setup - `nwis_inventory` and `nwis_data`. This shows that you can include additional calls to `tar_target()` to add more appliers to your branches. If you want to use a previous step's output, just use the target name from that step and **targets** will appropriately pass only the output relevant to each task target between the steps within `tar_map()`. We are going to add a few more steps to our static branching and there is already a hint for where we will add these ... *ahem* `#Insert step for tallying data here` and `#Insert step for plotting data here` *ahem*. 

#### Steps that require additional info per task

So far, we have used functions in static branching that only needed our state abbreviation, e.g. "WI" or "IL". What happens when we want to have other information used per task? For example, we need to save files per task and we want those to be passed into our step function. Easy! We can just edit the information we pass in for `values`. Currently, we are using a single-column `tibble` but that can easily have multiple columns and those columns can be used as arguments to `tar_target()` commands within `tar_map()`. We will try this out next!

<hr>

### :keyboard: Activity: Switch to a new branch

Before you edit any code, create a local branch called "appliers" and push that branch up to the remote location "origin" (which is the github host of your repository).

```
git checkout main
git pull origin main
git checkout -b appliers
git push -u origin appliers
```

The first two lines aren't strictly necessary when you don't have any new branches, but it's a good habit to head back to `main` and sync with "origin" whenever you're transitioning between branches and/or PRs.

<hr>

### :keyboard: Activity: Add two new appliers

#### Code

In *_targets.R*:

- [ ] Add a new step right after `nwis_data`. It should create R object targets called `tally_WI`, `tally_MI`, etc., should call the `tally_site_obs()` function (also already defined for you in *2_process/src/tally_site_obs.R*), and should make use of the targets created in `nwis_data`.

- [ ] We are about to add a fourth step to our static branching, where we create plot image files. First, we want to add our new file names to our branches defined in `values`. Add another column to the tibble called `state_plot_files` that includes *3_visualize/out/timeseries_WI.png*, *3_visualize/out/timeseries_MN.png*, etc. by editing`tibble(state_abb = states)` to be

```r
tibble(state_abb = states) %>% 
  mutate(state_plot_files = sprintf("3_visualize/out/timeseries_%s.png", state_abb))
```

- [ ] Add a fourth step to plot the data. This step should have a target name of `timeseries_png`, should call the `plot_site_data()` function (defined in *3_visualize/src/plot_site_data.R*), should use the image filename for each task stored in the `state_plot_files` column, and should make use of the targets created in `nwis_data` (no need to link to the `tally` targets).

- [ ] Make the two new function files (where `plot_site_data()` and `tally_site_obs()` are defined) available to the pipeline by adding `source()` calls to `_targets.R`.

- [ ] The `tally_site_obs()` function uses a function from the package **lubridate**. Add this package to the `packages` argument in your `tar_option_set()` call.

- [ ] Speaking of packages, we added `%>%` and `mutate` to `_targets.R` in order to add a new column to our task tibble. These are made available by the `dplyr` package which is included in `tidyverse`, and while `tidyverse` is loaded in `tar_option_set()`, it is not loaded when the top-level makefile is run. So, we need to add `library(dplyr)` to the top of `_targets.R`. One common practice is to wrap any `library(dplyr)` and `library(tidyverse)` calls used at the top of target makefiles with `suppressPackageStartupMessages()`. This hides those startup messages about masking functions and what pacakges are being attached. If we don't hide them, they will appear *every* time we run `tar_make()` which isn't necessary and can sometimes be distracting.

- [ ] Now that we have added an additional column in `values`, we have less certainty about what `tar_map()` will use as the suffix when naming branch targets. To control what is used as the suffix, you can specify what part of `values` to use by passing in the column name to the `names` argument within `tar_map()`. This guarantees that `_WI`, `_MN`, etc will be used and not the long image filenames (that could get messy!). Go ahead and add `names = state_abb` as the final argument to `tar_map()`.

#### Test

- [ ] Run `tar_make()`. Is it building a timeseries plot and a `tally` object for each state? If not, keep fiddling with your code until you get it to work.

- [ ] Check the contents of the *3_visualize/out* directory and inspect at least one of the plots. How do they look?

- [ ] Load the value of `tally_IL` to a variable of the same name in your global environment (hint: `?tar_load()`)

When you're feeling confident, creat the following outputs for comparison:
* an image from one of the new plots in *3_visualize/out*,
* a printout of the first 10 lines of `tally_IL`, and
* a copy of the image shown by `tar_visnetwork()`.

<hr>

#### Check your progress

To help you assess your pipeline, here's what the expected outputs should look like:

_* an image from one of the new plots in *3_visualize/out*, and_

![timeseries_WI](https://user-images.githubusercontent.com/12039957/82912759-71d6a280-9f3b-11ea-8e89-381ab350aeca.png)

_* a printout of the first 10 lines of `IL_tally`_

```r
> head(tally_IL, 10)
# A tibble: 10 x 4
# Groups:   Site, State [1]
   Site     State  Year NumObs
   <chr>    <chr> <dbl>  <int>
 1 05572000 IL     1908    332
 2 05572000 IL     1909    365
 3 05572000 IL     1910    365
 4 05572000 IL     1911    365
 5 05572000 IL     1912    337
 6 05572000 IL     1914    192
 7 05572000 IL     1915    365
 8 05572000 IL     1916    366
 9 05572000 IL     1917    365
10 05572000 IL     1918    365
```

_* a copy of the image shown by tar_visnetwork()._

![visnetwork_image](https://user-images.githubusercontent.com/13220910/127886177-4c632f4f-67a9-4a81-9758-7f317d7c72b6.png)

<hr>

### :keyboard: Activity: Spot the split-apply-combine (again)

- [ ] Check out the code for `tally_site_obs()`. To strengthen your familiarity with the *split-apply-combine* paradigm, can you isolate the *split*, *apply*, and *combine* operations within this **tidyverse** expression?
```r
site_data %>%
  mutate(Year = lubridate::year(Date)) %>%
  # group by Site and State just to retain those columns, since we're already only looking at just one site worth of data
  group_by(Site, State, Year) %>%
  summarize(NumObs = length(which(!is.na(Value))))
```

<hr>

#### Check your progress

Here's where I think the *split-apply-combine* paradigm is manifested in **tidyverse**:

The split is decided here:
```r
group_by(Site, State, Year) %>%
```

The `apply` is the expression
```r
length(which(!is.na(Value)))
```

And both `apply` and `combine` are orchestrated by
```r
summarize()
```

It's amazing how concise these actions can be in **tidyverse**, don't you think? The **targets** version would require more code to do the exact same operation, but it brings the special benefit of only (re)building those elements that aren't already up to date.

<hr> 

### :keyboard: Activity: Revise and rebuild a step

The timeseries plots aren't meant to be publication quality, but it would be nice to touch them up just a bit.

- [ ] Revise the title to include the `State` value from the first row of the `site_data` object.

- [ ] Run `tar_make()` to build the plots again. Only the targets `timeseries_png_WI`, `timeseries_png_MN`, etc should have built. Everything else should have been skipped.

- [ ] Copy your console output from the `tar_make()` you just ran and one of the updated plots for a comparison to the expected output.

<hr> 

#### Check your progress

_Copy your console output from the `tar_make()` you just ran_

Do you get something like this, where only six targets were rebuilt?

```r
v skip target oldest_active_sites
v skip target nwis_inventory_WI
v skip target nwis_inventory_IL
v skip target nwis_inventory_IN
v skip target nwis_inventory_MI
v skip target site_map_png
v skip target nwis_inventory_MN
v skip target nwis_inventory_IA
v skip target nwis_data_WI
v skip target nwis_data_IL
v skip target nwis_data_IN
v skip target nwis_data_MI
v skip target nwis_data_MN
v skip target nwis_data_IA
v skip target tally_WI
* start target timeseries_png_WI
  Plotting data for WI-04073500
* built target timeseries_png_WI
v skip target tally_IL
* start target timeseries_png_IL
  Plotting data for IL-05572000
* built target timeseries_png_IL
v skip target tally_IN
* start target timeseries_png_IN
  Plotting data for IN-03373500
* built target timeseries_png_IN
* start target timeseries_png_MI
  Plotting data for MI-04063522
* built target timeseries_png_MI
v skip target tally_MI
* start target timeseries_png_MN
  Plotting data for MN-05211000
* built target timeseries_png_MN
v skip target tally_MN
* start target timeseries_png_IA
  Plotting data for IA-05420500
* built target timeseries_png_IA
v skip target tally_IA
* end pipeline
```

_Copy ... one of the updated plots for a comparison to the expected output_

I edited `ggtitle(site_data$Site[1])` to be `ggtitle(sprintf("%s-%s", site_data$State[1], site_data$Site[1]))`, so my updated plot looks like

![updated_wi_plot](https://user-images.githubusercontent.com/13220910/119910012-d1370c00-bf1b-11eb-926e-05c69be70837.png)

<hr>

### :keyboard: Activity: Merge your new appliers

Now that we've added these new appliers and thoroughly tested them, your code is ready for a pull request. Go for it!

Now assign your course contact to review your PR. Either they or you can merge after any comments or change requests have been resolved.

</details>

<hr>

<details>
<summary><h2>Combiners</h2></summary>

So far we've implemented *split* and *apply* operations; now it's time to explore *combine* operations in **targets** pipelines.

In this section you'll add two *combiners* to serve different purposes - the first will combine all of the annual observation tallies into one giant table, and the second will summarize the set of state-specific timeseries plots generated by the task table. 

### Background

#### Approach

Given your current level of knowledge, if you were asked to add a target combining the tally outputs you would likely add a call to `tar_target` and use the branches as input to a `command` that aggregated the data. While this would certainly work, the number of inputs to a combiner should change if the number of tasks changes. If we hand-coded a combiner target with `tar_target` that accepted a set of inputs (e.g., `tar_target(combined_tallies, combine_tallies(tally_WI, tally_MI, [etc]))`), we'd need to manually edit the inputs to that function anytime we changed the `states` vector. That would be a pain and would make our pipeline susceptible to human error if we forgot or made a mistake in that editing. 

#### Implementation

The **targets** way to use combiners for static branching is to work with the `tar_combine()` function (recall that **combiners** are automatically applied to the output in dynamic branching). `tar_combine()` is set up in a similar way to `tar_target()`, where you supply the target name and a function to the target as the `command`. The difference is that the input to the `command` will be multiple targets passed in to the `...` argument. The output from a `tar_combine()` can be an R object or a file, but file targets need to have `format = "file"` passed in to `tar_combine()` and the function used as `command` must return the filepath.  

Some additional implementation considerations:

* In order to use `tar_combine()` with the output from `tar_map()`, you will need to save the output of `tar_map()` as an object. Thus, the branching declaration should look something like `mapped_output <- tar_map()` so that `mapped_output` can be used in your `tar_combine()` call.

* You can write your own combiner function or you can use built-in combiner functions for common types of combining (such as `bind_rows()`, `c()`, etc). If you write your own combiner function, it needs to be in a script sourced in the makefile using `source()`. The default combiner is `?vctrs::vec_c`, which is a a fancy version of `c()` that ensures the resulting vector keeps the common data type (e.g. factors remain factors).

* When you pass the output of `tar_map()` to `tar_combine()`, all branch output from `tar_map()` will be used by default. If you had multiple steps in your `tar_map()` (i.e. multiple calls to `tar_target()`), and you only want to combine results from one of those, you can add `unlist = FALSE` to your `tar_map()` call so that the `tar_map()` output remained in a nested list. This makes it possible to reference just the output from each `tar_target()` and use in `tar_combine()`. For example, if you had three steps in your `tap_map()` call and you wanted to combine only those branches from the third step that had a target name of `sum_resuts`, you could use `mapped_output[[3]]` or `mapped_output$sum_results` as the input to `tar_combine()`. 

* Within your `tar_combine()` function, pass the `...` to your `command` function by specifying `!!!.x` in its place. It feels strange, but has to do with how the function handles non-standard evaluation. You can see an example of using this syntax when you look at the default for `command` in thehelp file for `?tarchetypes::tar_combine()`.

* When specifying the `command` argument to `tar_combine()`, you need to include the argument, e.g. `command = my_function()`. Since `tar_combine()` has `...` as its second argument, anything else you pass in without the argument name will be considered part of `...`. It can result in some weird errors.

Don't worry if not all of this clicked yet. We are about to see it all in action!

<hr>

### :keyboard: Activity: Switch to a new branch

Before you edit any code, create a local branch called "combiners" and push that branch up to the remote location "origin" (which is the github host of your repository).

```
git checkout main
git pull origin main
git checkout -b combiners
git push -u origin combiners
```

The first two lines aren't strictly necessary when you don't have any new branches, but it's a good habit to head back to `main` and sync with "origin" whenever you're transitioning between branches and/or PRs.

<hr>

### :keyboard: Activity: Add a data combiner

#### Write `combine_obs_tallies()`

- [ ] Add a new function called `combine_obs_tallies` somewhere in *2_process/src/tally_site_obs.R*. The function declaration should be `function(...)`; when the function is actually called, you can anticipate that the arguments will be a bunch of tallies tibbles (**tidyverse** data frames). Your function should return the concatenation of these tibbles into one very tall tibble.

- [ ] Test your `combine_obs_tallies()` function. Run
  ```r
  source('2_process/src/tally_site_obs.R') # load `combine_obs_tallies()`
  tar_load(tally_WI)
  tar_load(tally_MN)
  tar_load(tally_IL)
  combine_obs_tallies(tally_WI, tally_MN, tally_IL)
  ```
  The result should be a tibble with four columns and as many rows as the sum of the number of rows in `WI_tally`, `MN_tally`, and `IL_tally`. If you don't have it right yet, keep fiddling and/or ask for help.

#### Prepare the makefile to use `combine_obs_tallies()`

- [ ] Move your static branching setup outside of your targets list and save above as an object called `mapped_by_state_targets`. It should look something like
  ```r
  mapped_by_state_targets <- tar_map(...)
  
  list(
    tar_target(oldest_active_sites, ...),
    
    tar_target(site_map_png, ...)
  )
  ```

- [ ] Now add `mapped_by_state_targets` as a target between `oldest_active_sites` and `site_map_png` in your list of targets.

- [ ] Add `unlist=FALSE` to your `tar_map()` call, so that we can reference only the branch targets from the `tally` step in `tar_combine()`.

#### Add your combiner target

- [ ] Add a new target between `mapped_by_state_targets` and the `site_map_png` target called `obs_tallies`. Instead of `tar_target()`, this will use `tar_combine()`.

- [ ] Populate your `tar_combine()` call with input for just the tally branches by subsetting the `tar_map()` output object, and the appropriate call to `combine_obs_tallies()` for the `command` (remember you will need `!!!.x`).

#### Test

Run `tar_make()` and then `tar_load(obs_tallies)`. Inspect the value of `obs_tallies`. Is it what you expected? Note your observations for a comparison with the expected answer.

<hr>

_Inspect the value of `obs_tallies`. Is it what you expected?_

Here's what my `obs_tallies` looks like. Your number of rows might vary slightly if you build this at a time when the available data have changed substantially, but the column structure and approximate number of rows ought to be about the same. If it looks like this, then it meets my expectations and hopefully also yours.
```
> obs_tallies
# A tibble: 738 x 4
# Groups:   Site, State [6]
   Site     State  Year NumObs
   <chr>    <chr> <dbl>  <int>
 1 04073500 WI     1898    365
 2 04073500 WI     1899    365
 3 04073500 WI     1900    365
 4 04073500 WI     1901    365
 5 04073500 WI     1902    365
 6 04073500 WI     1903    365
 7 04073500 WI     1904    366
 8 04073500 WI     1905    365
 9 04073500 WI     1906    365
10 04073500 WI     1907    365
# … with 728 more rows
```

<hr>

### :keyboard: Activity: Use the combiner target downstream

It's time to reap the rewards from your first combiner.

- [ ] Create a new target in *_targets.R* that takes advantage of your new combined tallies. Use the `plot_data_coverage()` function already defined for you (find it by searching or browsing the repository - remember `Ctrl-Shift-F.`), and pass in `obs_tallies` as the `oldest_site_tallies` argument. Set up your target to create a file named `"3_visualize/out/data_coverage.png"` and name the target appropriately. Remember to add a `source()` call to load the file with the new function near the top of *_targets.R*. Add this to your `list()` of targets after `obs_tallies` but before `site_map_png`, so that it is connected to the main pipeline.

- [ ] Test your new target by running `tar_make()`, then checking out *3_visualize/out/data_coverage.png*.

- [ ] Test your new pipeline by removing a state from `states` and running `tar_make()` once more. Did *3_visualize/out/data_coverage.png* get revised? If not, see if you can figure out how to make it so. Ask for help if you need it.

When you've got it, review you image of *3_visualize/out/data_coverage.png*.

<hr>

Great, you have a combiner hooked up from start to finish, and you probably learned some things along the way! It's time to add a second combiner that serves a different purpose - here, rather than produce a target that _contains_ the data of interest, we'll produce a combiner target that _summarizes_ the outputs of interest (in this case the state-specific .png files we've already created).

### Why do we need a summary target of outputs?

While this isn't necessary for the pipeline to operate, summarizing file output in large pipelines can be advantageous in some circumstances. Mainly, when we want to version control information about parts of the pipeline that were updated for ourselves or collaborators. We can't check in R object targets to GitHub and we usually avoid checking in data files (e.g. PNGs, CSVs, etc) to GitHub because of the file sizes. So, instead, we can combine some metadata about the file targets generated in the pipeline into a small text file, save in a `log/` folder, and commit that to GitHub. Then, any future runs of the pipeline that change any of the metadata we include in the summary file would be tracked as a change to that file.

The first step is to write a custom function to take a number of target names and generate a summary file using output from `tar_meta()`. We will refer to this file as an indicator file, where the file lines *indicate* the hash of the file. We will save as a CSV so that individual lines of the CSV can be tracked as changed or not. See below for a function that does exactly this!

```r
summarize_targets <- function(ind_file, ...) {
  ind_tbl <- tar_meta(c(...)) %>% 
    select(tar_name = name, filepath = path, hash = data) %>% 
    mutate(filepath = unlist(filepath))
  
  readr::write_csv(ind_tbl, ind_file)
  return(ind_file)
}
```

### :keyboard: Activity: Add a summary combiner

#### Try this summary function

- [ ] Inspect the code within `summarize_targets()`

- [ ] Run the code to create `summarize_targets()` as a function in your local environment.

- [ ] Test it out with a command such as
  ```r
  summarize_targets('test.csv', site_map_png, oldest_active_sites)
  ```
  Check out the contents of *test.csv*. Then when you're feeling clear on what happened, delete *test.csv* and clear your R Global Environment.

#### Prepare the makefile to use `summarize_targets()`

- [ ] Copy/paste the `summarize_targets()` function to its own R script called `2_process/src/summarize_targets.R`.

- [ ] Add this new file to the pipeline by including a call to `source()` near the top of `_targets.R`.

- [ ] Add another target after `obs_tallies` to build this second combiner. The new line should be:
  ```r
  tar_combine(
    summary_state_timeseries_csv,
    mapped_by_state_targets,
    command = summarize_targets('3_visualize/log/summary_state_timeseries.csv', !!!.x),
    format="file"
  )
  ```
  Note the use of the `log/` directory. The template repo had already set up any `src/` and `out/` folders for you, but `3_visualize/log/` does not exist yet. Before you can build this target, you will need to create this directory. Otherwise, the pipeline will throw an error.

- [ ] Run `tar_make()`. Inspect `'3_visualize/log/summary_state_timeseries.csv'`. Is that what you expect?

#### Test and revise `summary_state_timeseries_csv`

Hmm, you probably just discovered that *3_visualize/log/summary_state_timeseries.csv* used `summarize_targets()` for the `download`, `tally`, AND `plot` steps of the static branching. We could do that but what we really wanted to know was the metadata status for the plot file outputs only. 

- [ ] Adjust the input to `tar_combine()` for `summary_state_timeseries_csv` so that ONLY the timeseries plot step of `mapped_by_state_targets` is being passed into the combiner function.

- [ ] Now run `tar_make()` again, and check out *3_visualize/log/summary_state_timeseries.csv* once more. Do you only have the PNG files showing up now?

When you're feeling confident, review the contents of *3_visualize/out/data_coverage.png*, *3_visualize/log/summary_state_timeseries.csv*, and the figure generated by `tar_visnetwork()`.

<hr>

You're down to the last task for this section! I hope you'll find this one rewarding. After all your hard work, you're now in a position to create a **leaflet** map that will give you interactive access to the locations, identities, and timeseries plots of the Upper Midwest's oldest gages, all in one .html map. Ready?

#### Use the plots downstream

- [ ] Add another target to *_targets.R* that uses the function `map_timeseries()` (defined for you in `3_visualize`). `site_info` should be `oldest_active_sites`, `plot_info` should be `summary_state_timeseries_csv`, and the output should be written to `3_visualize/out/timeseries_map.html`. Name this target appropriately and put as the final target in your list.

- [ ] Add the three packages that `map_timeseries()` requires to the declaration in `tar_option_set()` at the top of *_targets.R*: `leaflet`, `leafpop`, and `htmlwidgets`.

#### Test

- [ ] Run `tar_make()`. Any surprises?

- [ ] Check out the results of your new map by opening *3_visualize/out/timeseries_map.html* in the browser. You should be able to hover and click on each marker.

- [ ] Add or subtract a state from the `states` vector and rerun `tar_make()`. Did you see the rebuilds and non-rebuilds that you expected? Did the html file change as expected?

#### Make a pull request

It's finally time to submit your work.

- [ ] Commit your code changes for this section and make sure you're `.gitignore`ing the new analysis products (the .png and .html files), but include your new file in the `log/` directory. Push your changes to the GitHub repo.

- [ ] Create a PR to merge the "{{ branch }}" branch into "main". Share a screenshot of *3_visualize/out/timeseries_map.html* and any thoughts you want to share in the PR description. 

</details>

<hr>

<details>
<summary><h2>Scale Up</h2></summary>

Your pipeline is looking great! It's time to put it through its paces and experience the benefits of a well-plumbed pipeline. The larger your pipeline becomes, the more useful are the tools you've learned in this course.

In this section you will:

* Expand the pipeline to include all of the U.S. states and some territories
* Learn one more method for making pipelines more robust to internet failures
* Practice the other branching method, dynamic branching 
* Modify the pipeline to describe temperature sites instead of discharge sites

### :keyboard: Activity: Check for targets udpates

Before you get started, make sure you have the most up-to-date version of **targets**:
```r
packageVersion('targets')
## [1] ‘0.5.0.9002’
```
You should have package version >= 0.5.0.9002. If you don't, reinstall with:
```r
remotes::install_github('ropensci/targets')
```

<hr>

### :keyboard: Activity: Switch to a new branch

Before you edit any code, create a local branch called "scale-up" and push that branch up to the remote location "origin" (which is the github host of your repository).

```
git checkout main
git pull origin main
git checkout -b scale-up
git push -u origin scale-up
```

The first two lines aren't strictly necessary when you don't have any new branches, but it's a good habit to head back to `main` and sync with "origin" whenever you're transitioning between branches and/or PRs.

<hr>

### :keyboard: Activity: Include all the states

#### Expand `states`

- [ ] Expand the pipeline to include all of the U.S. states and some territories. Specifically, modify the `states` target in **_targets.R**:

  ```r
  states <- c('AL','AZ','AR','CA','CO','CT','DE','DC','FL','GA','ID','IL','IN','IA',
              'KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH',
              'NJ','NM','NY','NC','ND','OH','OK','OR','PA','RI','SC','SD','TN','TX',
              'UT','VT','VA','WA','WV','WI','WY','AK','HI','GU','PR')
  ```

#### Test

- [ ] Run `tar_make()` once. Note what gets [re]built.

- [ ] Run `tar_make()` again. Note what gets [re]built.

- [ ] For fun, here are some optional math questions. Assume that you just added 46 new states, and each state data pull has a 50% chance of failing.
  1. What are the odds of completing all the data pulls in a single call to `tar_make()`?
  2. How many calls to `tar_make()` should you expect to make before the pipeline is fully built?

Comment to yourself on what you're seeing. 

<hr>

### :keyboard: Activity: Use fault tolerant approaches to running `tar_make()`

Rather than babysitting repeated `tar_make()` calls until all the states build, it's time to adapt our approach to running `tar_make()` when there are steps plagued by network failures. A lot of times, you just need to retry the download/upload again and it will work. This is not always the case though and sometimes, you need to address the failures. The *targets* package does not currently offer this fault tolerance, so the approaches discussed here are designed by our group to provide fault tolerance for tasks such as this data pull (including those where the "failures" are all real rather than being largely synthetic as in this project :wink:). 

#### Understand your options

There are a few choices to consider when thinking about fault tolerance in pipelines and they can be separated into two categories - how you want the full pipeline to behave vs. how you want to handle individual targets.  

Choices for handling errors in the full pipeline:

1. You want the pipeline build to come to a grinding hault if any of the targets throw an error.
2. You want to come back and rebuild the target that is failing but not let that stop other targets from building.

If you want the first approach, congrats! That's how the pipeline behaves by default and there is no need for you to change anything. If you want the pipeline to keep going but return to build that target later, you should add `error = 'continue'` to your `tar_option_set()` call. 

Now let's talk about handling errors for individual targets. There are also a few ideas to consider here.

1. If the target fails, you want that target to return no data and keep going. 
2. If the target fails, you want to retry building that target `n` times (in case of internet flakyness) before ultimately considering it a failed target. 

If you want a failure to still be considered a completed build, then consider implementing `tryCatch` in your download/upload function to gracefully handle errors, return something (e.g. `data.frame()`) from the function, and allow the code to continue. If you want to retry a target before moving on in the pipeline, then we can use the function `retry::retry()`. This is a function from the *retry* package, which you may or may not have installed. Go ahead and check that you have this package before continuing. 

Wrapping a target `command` with `retry()` will keep building that target until there are no errors OR until it runs out of `max_tries`. You can also set the `when` argument of `retry()` to declare what error message should initiate a rebuild (the input to `when` can be a [regular expression](https://r4ds.had.co.nz/strings.html#matching-patterns-with-regular-expressions)).

#### Test

- [ ] Add code to load the package *retry* at the top of your *_targets.R* file.

- [ ] Wrap the `get_site_data()` function in your static branching code with `retry()`. The `retry()` function should look for the error message matching `"Ugh, the internet data transfer failed!"` and should rerun `get_site_data()` a maximum of 30 times. 

- [ ] Now run `tar_make()`. It will redownload data for *all* of the states since we updated the `command` for `nwis_data`. It will take awhile since it is downloading all of them at least once and may need to retry some up to 30 times. Grab a tea or coffee while you wait (~ 10 min) - at least there's no babysitting needed!

#### Commit

- [ ] Commit and push your changes to GitHub. No need to make a PR yet, though; we'll keep working on this section for a few more minutes first before getting human feedback.

<hr> 

You've just run a fully functioning pipeline with 212 unique branches (53 states x 4 steps)! Imagine if you had coded that with a `for` loop and just one of those states threw an error? :grimacing:

Now that you have your pipeline running with static branching, let's try to convert it into the other type of branching, dynamic. 

### :keyboard: Activity: Switch to dynamic branching

In our scenario, it doesn't matter too much whether we pick static or dynamic branching. Both can work for us. I chose to show you static first because inspecting and building pipelines with dynamic branching can be more mysterious. In dynamic branching, the naming given to each branch target is assigned randomly and dynamic branch targets do not appear in the diagram produced by `tar_visnetwork()`. But despite those inconveniences, dynamic branching is needed in many situations in order to build truly robust pipelines, so here we go ...

#### Convert to dynamic branching

- [ ] First, let's drop back down to just a few states while we get this new branching set up. Change to `states <- c('WI', 'MN', 'MI')` and run `tar_destroy()` to reset our pipeline (note: use `tar_destroy()` very sparingly and deliberately, as it wipes all previous pipeline builds).

- [ ] We no longer need to use `tar_map()` to create a separate object containing our static branching output. In dynamic branching, we just add to individual `tar_target()` calls. We will move each of the four targets from `tar_map()` into the appropriate targets list individually. First, move your "splitter" target `nwis_inventory` into your list of targets just after `oldest_active_sites`.

- [ ] Let's adjust this target to follow dynamic branching concepts. In dynamic branching, the output of each target is always combined back into a single object. So, `filter()`ing this dataset by state is not actually going to do anything. Instead of splitting the data apart by a branching variable (remember we used `tibble(state_abb = states)`?) as we do in static branching, we will use the `state_cd` column from `oldest_active_sites` as a grouping variable in preparation of subsequent targets that will be applied over those groups. You need to then add a special *targets* grouping (`tar_group()`) for it to be treated appropriately. Lastly, the default "iteration" in dynamic branching is by list, but we just set it up to use groups, so we need to change that. In the end, your "splitter" target should look like this:

  ```r
  tar_target(nwis_inventory,
            oldest_active_sites %>%
             group_by(state_cd) %>%
             tar_group(),
           iteration = "group")
  ```

- [ ] Now to download the data! Copy your `tar_target()` code for the `nwis_data` target and paste as a target after your `nwis_inventory` target. Make two small changes: replace `state_abb` with `nwis_inventory$state_cd` & add `pattern = map(nwis_inventory)` as an argument to `tar_target()`. This second part is what turns this into a dynamic branching target. It will apply the `retry(get_site_data())` call to each of the groups we defined in `nwis_inventory`. Continuing this idea, we can still get the state abbreviation to pass to `get_site_data()` by using the `state_cd` column from `nwis_inventory`. Since we grouped by `state_cd`, this will only have the one value.

- [ ] Add the tallying step. Copy the `tar_target()` code for the `tally` target into your targets list. Add `pattern = map(nwis_data)` as the final argument to `tar_target()` to set that up to dynamically branch based on the same branching from the `nwis_data` target. 

- [ ] Since dynamic branching automatically combines the output into a single object, the `tally` target already represents the combined tallies per state. We no longer need `obs_tallies`! Delete that target :) Make sure you update the downstream targets that dependend on `obs_tallies` and have them use `tally` instead (just `data_coverage_png` in our case).

- [ ] We are on our final step to convert to dynamic branching - our timeseries plots. This is a bit trickier because we were using our static branching `values` table to define the PNG filenames, but now won't have available to us. Instead, we will build them as part of our argument directly in the function. First, copy the target code for `timeseries_png` into the list of targets. Replace `state_plot_files` in the `plot_site_data()` command with the `sprintf()` command used to define `values` in the `tar_map()` command, which creates the string with the filename. Replace `state_abb` with `unique(nwis_data$State)`. Add `pattern = map(nwis_data)` as the final argument to `tar_target`.

- [ ] Once again, dynamic branching will automatically combine the output into a single object. For file targets, that means a vector of the filenames. So, we need to change our `summary_state_timeseries_csv` target to take advantage of that. First, it can be a regular `tar_target()`, so replace `tar_combine()` with `tar_target()`. Next, delete `mapped_by_state_targets$timeseries_png` so that the very next argument to `tar_target()` is the command. Edit the second argument to the command to be `timeseries_png` instead of `!!!.x`. Note that I didn't ask you to add `pattern = map()` to this function. We don't need to add `pattern` here because we want to use the combined target as input, not each individual filename.

- [ ] We need to adjust the function we used in that last target because it was setup to handle the output from a static branching step, not a dynamic one. There are two differences: 1) the static branching output for the filenames was not a single object, but a collection of objects (hence, `...` as our second argument for `summarize_targets()`), and 2) the individual filenames are known by the static branching approach, but only the hashed target names for the files are known in the dynamic branching approach. To fix the first difference, go to the `3_summarize/src/summarize_targets.R` file and update the function to accept a vector rather than multiple vectors for the second argument. To fix the second difference, go back to your `_targets.R` file and add `names()` around the input `timeseries_png`. This passes in the targets name for the dynamically created files, not just the filenames. Otherwise, `tar_meta()` won't know what you are talking about. The last note is that *targets* v0.5.0.9000 complains about passing in a vector as "ambiguous". You can fix this by wrapping your file vector argument used in `tar_meta()` with `all_of()` in your `summarize_targets()` function to get rid of the message.

- [ ] Clean up! Delete any of the remaining static branching content. Delete the code that creates `mapped_by_state_targets` and make sure that `mapped_by_state_targets` does not appear in the your targets list.

- [ ] Run `tar_visnetwork()` and inspect your pipeline diagram. Do all the steps and dependencies make sense? Do you notice anything that is disconnected from the pipeline? You may have caught this during the previous clean up step, but my pipeline looks like this:

![image](https://user-images.githubusercontent.com/13220910/125475294-edf74bb6-cbbf-41b3-afa5-8373dfdfe3fd.png)

Do you see the function `combine_obs_tallies` in the bottom left that is disconnected from the pipeline? There are a few ways to move forward knowing that something is disconnected: 1) fixing it because it should be connected, 2) leaving it knowing that you will need it in the future, or 3) deleting it because it is no longer needed. We will do the third - go ahead and delete that function. It exists in *2_process/src/tally_site_obs.R*. Re-run `tar_visnetwork()`. It should no longer appear.

#### Test

- [ ] Now run `tar_make()`. Remember that we set this up to use only three states at first. What do you notice in your console as the pipeline builds with respect to target naming?

- [ ] Once your pipeline builds using dynamic branching across three states, change your `states` object back to the full list,

```r
states <- c('AL','AZ','AR','CA','CO','CT','DE','DC','FL','GA','ID','IL','IN','IA',
            'KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH',
            'NJ','NM','NY','NC','ND','OH','OK','OR','PA','RI','SC','SD','TN','TX',
            'UT','VT','VA','WA','WV','WI','WY','AK','HI','GU','PR')
```

- [ ] Run `tar_visnetwork()`. Is it the same or different since updating the states?

- [ ] Time to test the full thing! Run `tar_make()`. Since we used `tar_destroy()` between the last full state build and now, it will take awhile (~ 10 min).

#### Commit

- [ ] Commit and push your changes to GitHub. No need to make a PR yet, though; we'll keep working on this section for a few more minutes first before getting human feedback.

Once you've committed and pushed your changes to GitHub, comment about some of the differences you notice when running this pipeline using the dynamic branching approach vs our original static branching approach. Include a screenshot of the result in your viewer from your last `tar_visnetwork()` showing your dynamic branching pipeline.

<hr>

This is fun, right? A strong test of code is whether it can be transferred to solve a slightly different problem, so now let's try applying this pipeline to water temperature data instead of discharge data.

### Background: Multiple git branches

I'm about to ask you to do a few tricky/interesting things here with respect to git. Let's acknowledge them even though we won't explore them fully in this course:

* You'll be copying a git repository locally. Soon you'll have two local clones of the repository, both with `origin` pointing to your GitHub repository. This feels weird but turns out to be fine. If you wanted to pass code changes between your local clones, you'd push from one clone up to GitHub, then pull from GitHub into the second clone.
* You'll be branching off from code that is not yet merged to the "main" branch - this means that if you were to create a PR for the "{{ new-branch }}" branch you'd be committing all the changes from "{{ current-branch }}" as well as those you make on this new branch. Alternatively, if you created and merged a PR for "{{ current-branch }}" first, then a second PR of "{{ new-branch }}" would only show those changes specific to this branch. These considerations do come up in real projects - the key is to know what **will** happen so that you can make a decision about what you **want** to happen.
* Your new branch will be for a new parameter and so will have entirely different data from the discharge branch, while also having almost identical code. Consequently, I won't encourage you to merge "{{ new-branch }}" into the "main" branch; instead, you can just keep two live branches on GitHub, side by side. We sometimes use this approach of having multiple live branches to keep track of several manifestations of vizzies for different social media platforms - most of the content is the same, but the output file size and other final touches differ. It can be time intensive to apply updates to all the branches, so it's easiest to wait until the very end to branch out (once most of the shared code development is complete), but mulitple branches are certainly doable and can be useful in some projects.

The above notes are really just intended to raise your awareness about complicated things you can do with git and GitHub. When you encounter needs or situations like these in real projects, just remember to think before acting, and feel free to ask questions of your teammates to make sure you get the results you intend.

### :keyboard: Activity: Repurpose the pipeline

- [ ] Make a copy of your whole local repo folder. You can just use standard file copying methods (File Explorer, `cp`, whatever you want). Name this new top-level folder "ds-pipelines-targets-3-temperature". Create a new RStudio project from an existing directory, using "ds-pipelines-targets-3-temperature" as that directory, and open in a new RStudio session. 

- [ ] In this new project, create a second local branch, this time called "{{ new-branch }}", and push this new branch up to the remote location "origin". Check to make sure you're already on the "{{ current-branch }}" branch (e.g., with `git status` or by looking at the Git tab in RStudio), and then:
  ```
  git checkout -b {{ new-branch }}
  git push -u origin {{ new-branch }}
  ```

- [ ] Change the parameter code (`parameter` in *_targets.R*) from `00060` (flow) to `00010` (water temperature).

- [ ] Remove 'VT' and 'GU' from the `states` target in *_targets.R*. It turns out that NWIS returns errors for these two states/territories for temperature, so we'll just skip them.

#### Test

- [ ] Run `library(targets)` (because you're in a new R session).

- [ ] You copied the whole pipeline directory, and with it, the previous pipeline's `_targets/` directory and build status info. Let's wipe that out before we build this new pipeline with temperature data. Double check that you are in your `ds-pipelines-targets-3-temperature` RStudio project and then run `tar_destroy()`. USE THIS VERY CAUTIOUSLY AS IT WILL CAUSE YOU TO HAVE TO REBUILD EVERYTHING.  

- [ ] Build the full pipeline using `tar_make()`. Note the different console messages this time. It would be rare but there might be states that hit our `max_tries` cap of 30 and fail. This can create weird errors later in the pipeline. So, if you see some weird errors on some of the visualization steps, try running `tar_outdated()` to see if there are incomplete state data targets. If there are, no worries just run `tar_make()` again and it should complete.

When everything has run successfully, review the images from `timeseries_KY.png` and `data_coverage.png`. Take a second and peruse the other `timeseries_*.png` files. Did you find anything surprising?

<hr> 

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

- [ ] Create a PR to merge your branch into "main". In the PR description, post your favorite figure produced during the course and any other observations you want to share.

</details>

<hr>

<details>
<summary><h2>What's Next</h2></summary>

Congratulations, you've finished the course! :sparkles:

Now that you're on or working with the USGS Data Science team, you'll likely be using data pipelines like the one you explored here in your visualization and analysis projects. More questions will surely come up - when they do, you have some options:

1. Visit the [targets](https://docs.ropensci.org/targets/) documentation pages and [The targets R Package User Manual](https://books.ropensci.org/targets/)
1. If you're a member of the IIDD Data Science Branch, ask questions and share ideas in our *Function - Data Pipelines* Teams channel. If you're not a member, you are likely taking this course because you are working with someone who is. Reach out to them with questions/ideas.

</details>
