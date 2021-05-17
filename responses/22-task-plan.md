#### Check your progress

You should have seen this output when you ran `print(scmake('state_tasks'))`:

```r
$example_target_name
[1] "WI_data"

$example_command
[1] "get_site_data(sites_info=oldest_active_sites, state=I('WI'), parameter=parameter)"
```

If you're not there yet, keep trying until your output matches mine. Then proceed: 

### :keyboard: Activity: Create the task plan

#### Sketch the plan
`create_task_plan()` generates an R list that defines your plan. To use this function in *123_state_tasks.R*,

- [ ] Replace this code chunk
```r
# Return test results to the parent remake file
return(list(
  example_target_name = download_step$target_name(task_name='WI'),
  example_command = download_step$command(task_name='WI')
))
```
with this one:
```r
# Create the task plan
task_plan <- create_task_plan(
  task_names = YOUR_CODE_HERE,
  task_steps = YOUR_CODE_HERE,
  add_complete = FALSE)

# Return test results to the parent remake file
return(yaml::as.yaml(task_plan))
```

#### Flesh out the plan
Now modify the new block:

- [ ] Assign the task names you defined above to the `task_names` argument.

- [ ] Assign a `list` of steps to the `task_steps` argument. In this case there will just be one step in the list.

- [ ] Leave `add_complete = FALSE` as it is. Feel free to experiment later with changing this argument to `TRUE`, but it's not relevant to the current exercise. You can learn more about this and other arguments with a call to `?create_task_plan` if and when you're ready.

#### Test
Note that we're now returning `yaml::as.yaml(task_plan)` from this function. This is still a temporary return value but gives you a way to inspect what you've created. It's also possible to print out the raw value of `task_plan` - it's just an R list, after all - but converting it to YAML makes it more concise and human-readable. The `cat` call suggested next makes the YAML text print nicely to the console.

When you're ready, call `cat(scmake('state_tasks'))` and paste the output into a new comment on this issue.

<hr><h3 align="center">I'll respond when I see your comment.</h3>
