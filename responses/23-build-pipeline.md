
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

Answer the questions from 2 and 3 above in a new comment on this issue.

<hr><h3 align="center">I'll respond when I see your comment.</h3>
