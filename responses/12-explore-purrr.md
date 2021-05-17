### :keyboard: Activity: Spot the split-apply-combine

Hey, did you notice that there's a *split-apply-combine* action happening in this repo already?

Check out the `find_oldest_sites()` function:
```r
find_oldest_sites <- function(states, parameter) {
  purrr::map_df(states, find_oldest_site, parameter)
}
```
This function:
- *splits* `states` into each individual state
- *applies* `find_oldest_site` to each state
- *combines* the results back into a single `tibble`

and it all happened in just one line! The *split-apply-combine* operations we'll be exploring in this course require more code and are more useful for slow or fault-prone activities, but they follow the same general pattern.

Check out the documentation for `map_df` at `?purrr::map_df` or [online here](https://purrr.tidyverse.org/reference/map.html) if this function is new to you.

<hr><h3 align="center">When you're ready, comment again on this issue.</h3>
