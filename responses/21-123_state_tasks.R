do_state_tasks <- function(oldest_active_sites) {

  # Define task table rows
  # TODO: DEFINE A VECTOR OF TASK NAMES HERE

  # Define task table columns
  download_step <- create_task_step(
    step_name = 'download'
    # TODO: Make target names like "WI_data"
    # TODO: Make commands that call get_site_data()
  )

  # Return test results to the parent remake file
  return(list(
    example_target_name = download_step$target_name(task_name='WI', step_name='download'),
    example_command = download_step$command(task_name='WI', step_name='download')
  ))
}
