In this course you'll learn about tools for data-intensive pipelines: how to download many datasets, run many models, or make many plots. Whereas a `for` loop would work for many quick tasks, here our focus is on tools for managing sets of larger tasks that each take a long time and/or are subject to occasional failure.

A recurring theme in this activity will be the *split-apply-combine* paradigm, which has many implementations in many software languages because it is so darn useful for data analyses. It works like this:

1. *Split* a large dataset or list of tasks into logical chunks, e.g., one data chunk per lake in an analysis of many lakes.
1. *Apply* an analysis to each chunk, e.g., fit a model to the data for each lake.
1. *Combine* the results into a single orderly bundle, e.g., a table of fitted model coefficients for all the lakes.

There can be variations on this basic paradigm, especially for larger projects:

1. The choice of how to *Split* an analysis can vary - for example, it might be fastest to download data for chunks of 100 sites rather than downloading all 10000 sites at once or downloading each site independently.
1. Sometimes we have several *Apply* steps - for example, for each site you might want to munge the data, fit a model, extract the model parameters, _and_ make a diagnostic plot specific to that site.
1. The *Combine* step isn't always necessary to the analysis - for example, we may prefer to publish a collection of plot .png files, one per site, rather than combining all the site plots into a single unweildy report file. That said, we may still find it useful to _also_ create a table summarizing which plots were created successfully and which were not.


Assign yourself to this issue to explore the split-apply-combine paradigm further.

<hr>
<h3 align="center">I, the Learning Lab Bot, will sit patiently until you've assigned yourself to this issue.<p><p><em>Please remember to be patient with me, too - sometimes I need a few seconds and/or a refresh before you'll see my response.</em></h3>
