### :keyboard: Activity: Apply a downloading function to each state

Awesome, time for your first code changes :pencil2:.

- [ ] Write three **scipiper** targets in *remake.yml* to apply `get_site_data()` to each state in `states`. The targets should be named `wi_data`, `mn_data`, and `mi_data`.

- [ ] Modify the `sources` section of *remake.yml* as needed to make your pipeline executable.

- [ ] Modify the `main` target so that your new targets will be built by default.

- [ ] Test it: You should be able to run `scmake()` with no arguments to get everything built.

:bulb: Hint: the `get_site_data()` function already exists and shouldn't need modification. You can find it by browsing the repo or by hitting **Ctrl-.** in RStudio and then searching for "get_site_data".

When you're satisfied with your code, open a PR to merge the "three-states" branch into "master". Make sure to add `.remake`, `3_visualize/out`, and any *.DS_Store* files to your `.gitignore` file before committing anything. In the description box for your PR, include a screenshot or transcript of your console session where the targets get built.

<hr><h3 align="center">I'll respond in your new PR. You may need to refresh the PR page to see my response.</h3>
