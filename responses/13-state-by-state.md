### :keyboard: Activity: Apply a downloading function to each state

Awesome, time for your first code changes :pencil2:.

- [ ] Write three targets in *_targets.R* to apply `get_site_data()` to each state in `states` (insert these new targets under the `# TODO: PULL SITE DATA HERE` placeholder in `_targets.R`). The targets should be named `wi_data`, `mn_data`, and `mi_data`.

- [ ] Add a call to `source()` near the top of *_targets.R* as needed to make your pipeline executable.

- [ ] Test it: You should be able to run `tar_make()` with no arguments to get everything built.

:bulb: Hint: the `get_site_data()` function already exists and shouldn't need modification. You can find it by browsing the repo or by hitting **Ctrl-SHIFT-F.** in RStudio and then searching for "get_site_data".

When you're satisfied with your code, open a PR to merge the "three-states" branch into "main". Make sure to add `_targets/*`, `3_visualize/out/*`, and any *.DS_Store* files to your `.gitignore` file before committing anything. In the description box for your PR, include a screenshot or transcript of your console session where the targets get built.

<hr><h3 align="center">I'll respond in your new PR. You may need to refresh the PR page to see my response.</h3>
