Your pipeline is looking great, @{{ user.username }}! It's time to put it through its paces and experience the benefits of a well-plumbed pipeline. The larger your pipeline becomes, the more useful are the tools you've learned in this course.

In this issue you will:

* Expand the pipeline to include all of the U.S. states and some territories
* Learn one more **scipiper** tool, the `loop_tasks()` function
* Modify the pipeline to describe temperature sites instead of discharge sites

### :keyboard: Activity: Check for scipiper udpates

Before you get started, make sure you have the most up-to-date version of **scipiper**:
```r
packageVersion('scipiper')
## [1] ‘0.0.20’
```
You should have package version >= 0.0.20. If you don't, reinstall with:
```r
remotes::install_github('USGS-R/scipiper')
```
