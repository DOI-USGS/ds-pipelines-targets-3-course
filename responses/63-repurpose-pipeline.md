This is fun, right? A strong test of code is whether it can be transferred to solve a slightly different problem, so now let's try applying this pipeline to water temperature data instead of discharge data.

#### Background: Multiple git branches

I'm about to ask you to do a few tricky/interesting things here with respect to git. Let's acknowledge them even though we won't explore them fully in this course:

* You'll be copying a git repository locally. Soon you'll have two local clones of the repository, both with `origin` pointing to your GitHub repository. This feels weird but turns out to be fine. If you wanted to pass code changes between your local clones, you'd push from one clone up to GitHub, then pull from GitHub into the second clone.
* You'll be branching off from code that is not yet merged to the "main" branch - this means that if you were to create a PR for the "{{ new-branch }}" branch you'd be committing all the changes from "{{ current-branch }}" as well as those you make on this new branch. Alternatively, if you created and merged a PR for "{{ current-branch }}" first, then a second PR of "{{ new-branch }}" would only show those changes specific to this branch. These considerations do come up in real projects - the key is to know what **will** happen so that you can make a decision about what you **want** to happen.
* Your new branch will be for a new parameter and so will have entirely different data from the discharge branch, while also having almost identical code. Consequently, I won't encourage you to merge "{{ new-branch }}" into the "main" branch; instead, you can just keep two live branches on GitHub, side by side. We sometimes use this approach of having multiple live branches to keep track of several manifestations of vizzies for different social media platforms - most of the content is the same, but the output file size and other final touches differ. It can be time intensive to apply updates to all the branches, so it's easiest to wait until the very end to branch out (once most of the shared code development is complete), but mulitple branches are certainly doable and can be useful in some projects.

The above notes are really just intended to raise your awareness about complicated things you can do with git and GitHub. When you encounter needs or situations like these in real projects, just remember to think before acting, and feel free to ask questions of your teammates to make sure you get the results you intend.

### :keyboard: Activity: Repurpose the pipeline

- [ ] Make a copy of your whole local repo folder. You can just use standard file copying methods (File Explorer, `cp`, whatever you want). Name this new top-level folder "ds-pipelines-3-temperature". Open a new RStudio session with "ds-pipelines-3-temperature" as the project.

- [ ] Create a second local branch, this time called "{{ new-branch }}", and push this new branch up to the remote location "origin". Check to make sure you're already on the "{{ current-branch }}" branch (e.g., with `git status` or by looking at the Git tab in RStudio), and then:
  ```
  git checkout -b {{ new-branch }}
  git push -u origin {{ new-branch }}
  ```

- [ ] Change the parameter code (`parameter` in *remake.yml*) from `00060` (flow) to `00010` (water temperature).

- [ ] Remove 'VT' and 'GU' from the `states` target in *remake.yml*. It turns out that NWIS returns errors for these two states/territories for temperature, so we'll just skip them.

#### Test

- [ ] Run `library(scipiper)` (because you're in a new R session) and then `scmake()`. Note the different console messages this time.

When everything has run successfully, use a comment to share the images from timeseries_KY.png, timeseries_VT.png, and data_coverage.png. Include any observations you want to share about the build.

<hr><h3 align="center">I'll respond when I see your comment.</h3>
