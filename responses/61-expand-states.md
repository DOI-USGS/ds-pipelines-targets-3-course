### :keyboard: Activity: Include all the states

#### Expand `states`

- [ ] Expand the pipeline to include all of the U.S. states and some territories. Specifically, modify the `states` target in **remake.yml**:

  ```yml
  states:
    command: c(I(c(
      'AL','AZ','AR','CA','CO','CT','DE','DC','FL','GA','ID','IL','IN','IA',
      'KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH',
      'NJ','NM','NY','NC','ND','OH','OK','OR','PA','RI','SC','SD','TN','TX',
      'UT','VT','VA','WA','WV','WI','WY','AK','HI','GU','PR')))
  ```

#### Test

- [ ] Run `scmake()` once. Note what gets [re]built.

- [ ] Run `scmake()` again. Note what gets [re]built.

- [ ] For fun, here are some optional math questions. Assume that you just added 46 new states, and each state data pull has a 50% chance of failing.
  1. What are the odds of completing all the data pulls in a single call to `scmake()`?
  2. How many calls to `scmake()` should you expect to make before the pipeline is fully built?

Comment on what you're seeing. 

<hr><h3 align="center">I'll respond when I see your comment.</h3>
