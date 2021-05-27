#### Check your progress

To help you assess your pipeline, here's what I would have put in that comment:

_* an image from one of the new plots in *3_visualize/out*, and_

![timeseries_WI](https://user-images.githubusercontent.com/12039957/82912759-71d6a280-9f3b-11ea-8e89-381ab350aeca.png)

_* a printout of the first 10 lines of `IL_tally`_

```r
> head(tally_IL, 10)
# A tibble: 10 x 4
# Groups:   Site, State [1]
   Site     State  Year NumObs
   <chr>    <chr> <dbl>  <int>
 1 05572000 IL     1908    332
 2 05572000 IL     1909    365
 3 05572000 IL     1910    365
 4 05572000 IL     1911    365
 5 05572000 IL     1912    337
 6 05572000 IL     1914    192
 7 05572000 IL     1915    365
 8 05572000 IL     1916    366
 9 05572000 IL     1917    365
10 05572000 IL     1918    365
```

### :keyboard: Activity: Spot the split-apply-combine (again)

- [ ] Check out the code for `tally_site_obs()`. To strengthen your familiarity with the *split-apply-combine* paradigm, can you isolate the *split*, *apply*, and *combine* operations within this **tidyverse** expression?
```r
site_data %>%
  mutate(Year = lubridate::year(Date)) %>%
  # group by Site and State just to retain those columns, since we're already only looking at just one site worth of data
  group_by(Site, State, Year) %>%
  summarize(NumObs = length(which(!is.na(Value))))
```

Give your answer to the activity in a comment on this issue.

<hr><h3 align="center">I'll respond when I see your comment.</h3>
