### :keyboard: Activity: Use the combiner target downstream

It's time to reap the rewards from your first combiner.

- [ ] Create a new target in *_targets.R* that takes advantage of your new combined tallies. Use the `plot_data_coverage()` function already defined for you (find it by searching or browsing the repository - remember `Ctrl-Shift-F.`), and pass in `obs_tallies` as the `oldest_site_tallies` argument. Set up your target to create a file named `"3_visualize/out/data_coverage.png"` and name the target appropriately. Remember to add a `source()` call to load the file with the new function near the top of *_targets.R*. Add this to your `list()` of targets after `obs_tallies` but before `site_map_png`, so that it is connected to the main pipeline.

- [ ] Test your new target by running `tar_make()`, then checking out *3_visualize/out/data_coverage.png*.

- [ ] Test your new pipeline by removing a state from `states` and running `scmake()` once more. Did *3_visualize/out/data_coverage.png* get revised? If not, see if you can figure out how to make it so. Ask for help if you need it.

When you've got it, share the image in *3_visualize/out/data_coverage.png* as a comment.

<hr><h3 align="center">I'll respond when I see your comment.</h3>
