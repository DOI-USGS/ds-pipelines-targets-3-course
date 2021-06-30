In the last issue you noted some inefficiencies with writing out many nearly-identical targets within a remake.yml:
1. It's a pain (more typing and potentially a very long *_targets.R* file) to add new sites.
2. Potential for errors (more typing, more copy/paste = more room for making mistakes).

In this issue we'll fix those inefficiencies by adopting the *branching* approach supported by **targets** and the support package **tarchetypes**.

### Definitions

**Branching** in **targets** refers to the approach of scaling up a pipeline to accomodate many tasks. It is the **targets** implementation of the *split-apply-combine* operation. In essence, we *split* a dataset into some number of **tasks**, then to each task we *apply* one or more analysis **steps**. Branches are the resulting targets for each unique task-and-step match.

In the example analysis for this course, each task is a state and the first step is a call to `get_site_data()` for that state's oldest monitoring site. Later we'll create additional steps for tallying and plotting observations for each state's site. See the image below for a conceptual model of branching for this course analysis.

![Branches](https://user-images.githubusercontent.com/13220910/119408393-3c2ddc00-bcab-11eb-812a-598d7ba07d00.jpg)

We implement branching in two ways: as **static branching**, where the task targets are predefined before the pipeline runs, and **dynamic branching**, where task targets are defined while the pipeline runs.

In this issue you'll adjust the existing pipelining to use branching for this analysis of USGS's oldest gages.
