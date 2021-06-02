
### :keyboard: Activity: Use fault tolerant approaches to running `tar_make()`

Rather than babysitting repeated `tar_make()` calls until all the states build, it's time to adapt our approach to running `tar_make()` when there are steps plagued by network failures. A lot of times, you just need to retry the download/upload again and it will work. This is not always the case though and sometimes, you need to address the failures. The *targets* package does not currently offer this fault tolerance in the package, so the approaches discussed here are designed by our group to provide fault tolerance for tasks such as this data pull (including those where the "failures" are all real rather than being largely synthetic as in this project :wink:). 

#### Understand your options

First, there are some considerations to make within your functions doing the data download or upload: what do you want to happen if there is a failure? There are 3 choices I see here: 

1. You want the pipeline build to come to a grinding hault and not skip the erring target.
2. You want to come back and rebuild the target that is failing but not let that stop other targets from building.
3. If the target fails, you don't want to rebuild you just want that target to not have data. 

If you want the first approach, congrats! That's how the pipeline behaves by default and there is not need for you to change anything. If you want the pipeline to keep going but return to build that target later, you should add `error = 'continue'` to your `tar_option_set()` call. Lastly, if you want a failure to still be considered a completed build, then consider implementing `tryCatch` in your download/upload function to gracefully handle errors and allow the code to continue.

Another approach to building fault tolerance is to limit the number of times you have to run to `tar_make()` in your console. We have our own approach and it involves a `while` loop and the `try()` function. It's a bit clever, so spend some time here digesting the function if you want. Bottom line is that it will keep running `tar_make()` until there are no errors OR until it runs out of `num_tries`.

```r
retry_tar_make <- function(tar_name_pattern = everything(), num_tries = 10) {
  while(num_tries){
    x <- try(tar_make(eval(tar_name_pattern)))
    if(!is(x, 'try-error')) break
    num_tries <- num_tries - 1
  }
}
```

A couple of quirks with using this function: 

1. It cannot appear anywhere that is connected to your pipeline makefile because it calls `tar_make()` (you will get an error). So, my recommendation is to include this in your project `README.md` file.
2. You _cannot_ have `error = 'continue'` set in `tar_option_set()` or `retry_tar_make()` will not recognize that your pipeline threw an error and will break out of the `while` loop.

One additional fun implementation is to only retry for a subset of targets. For example, in our pipeline, we may only want the download steps to retry. If a plotting step throws an error, it is likely something we need to go debug and not due to internet failures. So, if we were to retry only the download steps, we could run something like this:

```r
retry_tar_make(starts_with("nwis_data"))
```

Once your flaky downloads were complete, then you could carry on with `tar_make()` as usual.

#### Test

- [ ] Add the `retry_tar_make()` code to your README.md file with a comment about when/why you would use it.

- [ ] Run the code for `retry_tar_make()` so that the function is available in your local environment.

- [ ] Run `retry_tar_make()`. Grab a tea or coffee if you like - it's a long run (~7-minutes), but at least there's no babysitting needed!

#### Commit

- [ ] Commit and push your changes to GitHub. No need to make a PR yet, though; we'll keep working on this issue for a few more minutes first before getting human feedback.

Comment once you've committed and pushed your changes to GitHub.

<hr><h3 align="center">I'll respond when I see your comment.</h3>
