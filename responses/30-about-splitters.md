In the last issue you noted a lingering inefficiency: When you added Illinois to the `states` vector, your task table pipeline built `WI_data`, `MN_data`, and `MI_data` again even though there was no need to download those files again. This happened because those three targets each depend on `oldest_active_sites`, the inventory object, and that object changed to include information about a gage in Illinois. As I noted in that issue, it would be ideal if each task target only depended on exactly the values that determine whether the data need to be downloaded again. But we need a new tool to get there: a **splitter**.

The splitter we're going to create in this issue will split `oldest_active_sites` into a separate table for each state. In this case each table will be just one row long, but there are plenty of situations where the inputs to a set of tasks will be larger, even after splitting into task-size chunks. Some splitters will be quick to run and others will take a while, but either way, we'll be saving ourselves time in the overall pipeline!

### Background

#### The slow way to split

In general, **scipiper** best practices require that each `command` creates exactly one output, either an R object or a file. To follow this policy, we *could* write a function that would take the full inventory and one state name and return a one-row table.
```r
get_state_inventory <- function(sites_info, state) {
  site_info <- dplyr::filter(sites_info, state_cd == state)
}
```
And then we could insert an initial task table step where we pulled out that state's information before passing it to the next step, such that each state's resulting targets in *123_state_tasks.yml* would follow this pattern:
```yml
  WI_inventory:
    command: get_state_inventory(sites_info=oldest_active_sites, I('WI'))
  WI_data:
    command: get_site_data(sites_info=WI_inventory, state=I('WI'), parameter=parameter)
```
...but ugh, what a lot of text to add for such a simple operation! Also, suppose that `sites_info` was a file that took a long time to read in - we've encountered cases like this for large spatial data files, for example - you'd have to re-open the file for each and every call to `get_state_inventory()`, which would be excruciatingly slow for a many-state pipeline.

Fortunately, there's a better way.

#### The fast way to split

Instead of calling `get_state_inventory()` once for each state, we'll go ahead and write a single **splitter** function that accepts `oldest_active_sites` and creates a single-row table for each state. It will be faster both to type (fewer targets) and to run (no redundant reloading of the data to split). The key is that instead of *just* creating as many tables as there are states, we'll *also* create a single summary file that concisely describes each of those outputs all in one place. In this way we only sort of break the "one-function, one-output" rule - we are creating many outputs, true, but one of them is an output that we can use as a **scipiper** target because it reflects the overall behavior of the function.

#### Hashes

Ideally, we should design our summary file so that it changes anytime any of the split-up outputs change. We'll get more into the rationale in a later issue (very briefly, this approach makes it possible to use the summary file as an effective dependency of other pipeline targets). For now, I'm asking you to accept on faith that summary files should reflect the split-up outputs in a meaningful way.

To meet this need, our favorite format for summary files is a YAML of key-value pairs, where each key is a filename and each value is a **hash** of that file. A **hash** is a shortish character string (usually 16-32 characters) that describes the contents of a larger file or object. There are a number of algorithms for creating hashes (e.g., MD5, SHA-2, and SHA-3), but the cool feature that unites them all is that hashes are intended to be unique - if the contents of two files are even just slightly different, their hashes will always (OK, almost always) be different.

Explore the hash idea yourself using the `digest::digest()` function on R objects or the `tools::md5sum()` function on files. For example, you can hash your *remake.yml* file and get something like this:
```r
> tools::md5sum('remake.yml')
                        remake.yml 
"96b30271e93f4729ba4cbc6271c694df" 
```
and then if you change it just a tiny bit - add a newline, for example - you are more or less guaranteed to get a different hash:
```r
> tools::md5sum('remake.yml')
                        remake.yml 
"9268e621b96ec9d35e9d9c0c2d58c19d"
```

Hash algorithms come from cryptography, which makes them extra cool :detective:

#### Your mission

In this issue you'll create a splitter to make your task table more efficient in the face of a changing inventory in `oldest_active_sites`. Your splitter function will generate a separate one-row inventory file for each state, plus a YAML file that summarizes all of the single-state inventories with a filenames and hashes roughly like this:
```yml
1_fetch/tmp/inventory_IL.tsv: 4c59d14d16b3af05dff6e6d6dfc8aac9
1_fetch/tmp/inventory_MI.tsv: fed321c051ee99e2c7b163c5c4c10320
1_fetch/tmp/inventory_MN.tsv: d2bff76a0631abf055421b86d033d80c
1_fetch/tmp/inventory_WI.tsv: b6167db818f91d792ec639b6ec4faf68
```

Ready?
