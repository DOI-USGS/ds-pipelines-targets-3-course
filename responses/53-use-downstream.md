### :keyboard: Activity: Use the combiner target downstream

It's time to reap the rewards from your first combiner.

- [ ] Create a new target in *remake.yml* that takes advantage of your new combined tallies. Use the `plot_data_coverage()` function already defined for you (find it by searching or browing the repository - remember `Ctrl-.`), and pass in `state_tasks` as the `oldest_site_tallies` argument. Set up your target to create a file named "3_visualize/out/data_coverage.png". Remember to add the source file to the `sources` list in *remake.yml*, and set up your pipeline to build this new target as part of the default build.

- [ ] Test your new target by running `scmake()`, then checking out *3_visualize/out/data_coverage.png*.

- [ ] Test your new pipeline by removing a state from `states` and running `scmake()` once more. Did *3_visualize/out/data_coverage.png* get revised? If not, see if you can figure out how to make it so. Ask for help if you need it.

When you've got it, share the image in *3_visualize/out/data_coverage.png* as a comment.

<hr><h3 align="center">I'll respond when I see your comment.</h3>
