In the last issue you noted some inefficiencies with writing out many nearly-identical targets within a remake.yml:
1. It's a pain (more typing and potentially a very long *remake.yml* file) to add new sites.
2. You have to run and re-run `scmake()` if any target breaks along the way.

In this issue we'll fix those inefficiencies by adopting the *task table* approach supported by **scipiper**.

### Definitions

A **task table** is a concept. The idea is that you can think of a *split-apply-combine* operation in terms of a table: each row of the table is a split (a **task**) and each column is an apply activity (a **step**). In the example analysis for this course, each row is a state and the first column contains calls to `get_site_data()` for that state's oldest monitoring site. Later we'll create additional steps for tallying and plotting observations for each state's site. A **task step** is a cell within this conceptual table.

![Task table](https://user-images.githubusercontent.com/12039957/82353967-2584e300-99ce-11ea-919b-735ec9182ed2.png)

A task table is "conceptual" because it doesn't exist as a table in R. We implement it in two ways: as a **task plan**, which is a nested R list defining all the tasks and steps, and as a **task remakefile**, which is an automatically generated scipiper YAML file much like the `remake.yml` you're already working with.

In this issue you'll create a task plan and task remakefile for this analysis of USGS's oldest gages.
