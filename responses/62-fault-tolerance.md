
### :keyboard: Activity: Use fault tolerant approaches to running `tar_make()`

Rather than babysitting repeated `tar_make()` calls until all the states build, it's time to adapt our approach to running `tar_make()` when there are steps plagued by network failures. A lot of times, you just need to retry the download/upload again and it will work. This is not always the case though and sometimes, you need to address the failures. The *targets* package does not currently offer this fault tolerance, so the approaches discussed here are designed by our group to provide fault tolerance for tasks such as this data pull (including those where the "failures" are all real rather than being largely synthetic as in this project :wink:). 

#### Understand your options

There are a few choices to consider when thinking about fault tolerance in pipelines and they can be separated into two categories - how you want the full pipeline to behave vs. how you want to handle individual targets.  

Choices for handling errors in the full pipeline:

1. You want the pipeline build to come to a grinding hault if any of the targets throw an error.
2. You want to come back and rebuild the target that is failing but not let that stop other targets from building.

If you want the first approach, congrats! That's how the pipeline behaves by default and there is no need for you to change anything. If you want the pipeline to keep going but return to build that target later, you should add `error = 'continue'` to your `tar_option_set()` call. 

Now let's talk about handling errors for individual targets. There are also a few ideas to consider here.

1. If the target fails, you want that target to return no data and keep going. 
2. If the target fails, you want to retry building that target `n` times (in case of internet flakyness) before ultimately considering it a failed target. 

If you want a failure to still be considered a completed build, then consider implementing `tryCatch` in your download/upload function to gracefully handle errors, return something (e.g. `data.frame()`) from the function, and allow the code to continue. If you want to retry a target before moving on in the pipeline, then we can use the function `retry::retry()`. This is a function from the *retry* package, which you may or may not have installed. Go ahead and check that you have this package before continuing. 

Wrapping a target `command` with `retry()` will keep building that target until there are no errors OR until it runs out of `max_tries`. You can also set the `when` argument of `retry()` to declare what error message should initiate a rebuild (the input to `when` can be a [regular expression](https://r4ds.had.co.nz/strings.html#matching-patterns-with-regular-expressions)).

#### Test

- [ ] Add code to load the package *retry* at the top of your *_targets.R* file.

- [ ] Wrap the `get_site_data()` function in your static branching code with `retry()`. The `retry()` function should look for the error message matching `"Ugh, the internet data transfer failed!"` and should rerun `get_site_data()` a maximum of 10 times. 

- [ ] Now run `tar_make()`. It will redownload data for *all* of the states since we updated the `command` for `nwis_data`. It will take awhile since it is downloading all of them at least once and may need to retry some up to 10 times. Grab a tea or coffee while you wait (~ 10 min) - at least there's no babysitting needed!

#### Commit

- [ ] Commit and push your changes to GitHub. No need to make a PR yet, though; we'll keep working on this issue for a few more minutes first before getting human feedback.

Comment once you've committed and pushed your changes to GitHub.

<hr><h3 align="center">I'll respond when I see your comment.</h3>
