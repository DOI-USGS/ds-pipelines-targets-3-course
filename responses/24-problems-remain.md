#### Check your progress

Here are my answers to the above questions:

_Q: 2. Add `'IL'` to the `states` target. Then call `tar_make()` again (you may have to run it multiple times to get passed [pretend] failures). It builds `data_IL` for you right? Cool! But there's something inefficient happening here, too - what is it? Can you guess why this is happening?_

A: It built `WI_data`, `MN_data`, and `MI_data` again even though there was no need to download those files again. This happened because those three targets each depend on `oldest_active_sites`, the inventory object, and that object changed to include information about a gage in Illinois. It would be ideal if each branch only depended on exactly the values that determine whether the data need to be downloaded again.

_Q: 3. Make a small change to the `get_site_data()` function: change `Sys.sleep(2)` to `Sys.sleep(0.5)`. Then call `tar_make()` again (and again and again if you get [pretend] internet failures). What happened?_

A: It skipped `oldest_active_sites` and then rebuilt each of the branches, `nwis_data_MI`, `nwis_data_MN`, `nwis_data_WI`, and `nwis_data_IL`. **targets** knows that the function updated and that these targets depend on that function. So cool! But the change we made doesn't actually change the output files from this function, but **targets** doesn't know that; it noticed a change in the function and rebuilt all of the targets that used it. The good thing is that any targets that depend on these `nwis_data_` targets would not rebuild because they wouldn't have changed since the last build. Also a reminder as to why it is a good idea to keep functions focused on smaller, specific activities. The more that the function does, the more opportunities there are for you to make updates/fixes/improvements, and you may end up rebuilding more than you want to. 

We'll deal with (2) in the next issue.

### :keyboard: Activity: Create a PR with your new branching technique

You now have a functioning pipeline that uses branching to download data for the oldest USGS streamgage in 4 different states! Go ahead and commit these changes to `_targets.R` to your "{{ branch }}"" branch and then open a Pull Request.

<hr><h3 align="center">I'll respond when I see your PR.</h3>
