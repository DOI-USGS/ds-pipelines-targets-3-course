In the last issue you noted some inefficiencies with writing out many nearly-identical targets within a remake.yml:
1. It's a pain (more typing and potentially a very long *remake.yml* file) to add new sites.
2. Potential for errors (more typing, more copy/paste = more room for making mistakes).

In this issue we'll fix those inefficiencies by adopting the *branching* approach supported by **targets** and the support package **tarchetypes**.

### Definitions

**Branching** in **targets** refers to the approach of scaling up a pipeline to accomodate many tasks. It is the **targets** implementation of the *split-apply-combine* operation. In essence, we have some set of **tasks** (the "split"), where we want to do some number of **steps** (the "apply") per task. Branches are the connections between each unique task-and-step match.

In the example analysis for this course, each task is a state and the first step is a call to `get_site_data()` for that state's oldest monitoring site. Later we'll create additional steps for tallying and plotting observations for each state's site. See the image below for a conceptual model of branching for this course analysis.

![Task table](https://user-images.githubusercontent.com/12039957/82353967-2584e300-99ce-11ea-919b-735ec9182ed2.png)

We implement branching in two ways: as **static branching**, where the tasks are predefined before the pipeline runs, and **dynamic branching**, where tasks are defined within the pipeline targets.

In this issue you'll adjust the existing pipelining to use branching for this analysis of USGS's oldest gages.
