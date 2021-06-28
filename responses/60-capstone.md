Your pipeline is looking great, @{{ user.username }}! It's time to put it through its paces and experience the benefits of a well-plumbed pipeline. The larger your pipeline becomes, the more useful are the tools you've learned in this course.

In this issue you will:

* Expand the pipeline to include all of the U.S. states and some territories
* Learn one more method for making pipelines more robust to internet failures
* Practice the other branching method, dynamic branching 
* Modify the pipeline to describe temperature sites instead of discharge sites

### :keyboard: Activity: Check for targets udpates

Before you get started, make sure you have the most up-to-date version of **targets**:
```r
packageVersion('targets')
## [1] ‘0.5.0.9002’
```
You should have package version >= 0.5.0.9002. If you don't, reinstall with:
```r
remotes::install_github('ropensci/targets')
```
