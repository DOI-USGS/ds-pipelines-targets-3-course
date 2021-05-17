### :keyboard: Activity: Switch to a new branch

Before you edit any code, create a local branch called "{{ branch }}" and push that branch up to the remote location "origin" (which is the github host of your repository).

```
git checkout master
git pull origin master
git checkout -b {{ branch }}
git push -u origin {{ branch }}
```

The first two lines aren't strictly necessary when you don't have any new branches, but it's a good habit to head back to `master` and sync with "origin" whenever you're transitioning between branches and/or PRs.

<hr><h3 align="center">Comment on this issue once you've created and pushed the "{{ branch }}" branch.</h3>
