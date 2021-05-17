#### Check your progress

Here's where I think the *split-apply-combine* paradigm is manifested in **tidyverse**:

The split is decided here:
```r
group_by(Site, State, Year) %>%
```

The `apply` is the expression
```r
length(which(!is.na(Value)))
```

And both `apply` and `combine` are orchestrated by
```r
summarize()
```

It's amazing how concise these actions can be in **tidyverse**, don't you think? The **scipiper** version would require a lot more code to do the exact same operation, but it brings the special benefit of only (re)building those elements that aren't already up to date.

### :keyboard: Activity: Revise and rebuild a step

The timeseries plots aren't meant to be publication quality, but it would be nice to touch them up just a bit.

- [ ] Revise the title to include the `State` value from the first row of the `site_data` object.

- [ ] Run `scmake()` to build the plots again. What happens? Do you know why?

- [ ] Run `scmake('state_tasks', force=TRUE)` to force the issue. What happens now? Why should you be uncomfortable with this solution?

Add your answers to a new comment on this issue.

<hr><h3 align="center">I'll respond when I see your comment.</h3>
