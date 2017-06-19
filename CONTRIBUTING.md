# `cnx-recipes` Contributing Guidelines


## Use a topic branch
*(lifted from [this](https://github.com/puppetlabs/puppet/blob/master/CONTRIBUTING.md))*

* Create a topic branch from where you want to base your work.
  * This is usually the master branch.
  * Only target release branches if you are certain your fix must be on that
    branch.
  * Please avoid working directly on the `master` branch.
* Make commits of logical units.
* Check for unnecessary whitespace with `git diff --check` before committing.
* Make sure your commit messages are in the proper format.

```
    Add additional snippet for unnumbered appendix tables

    If needed, the first paragraph of a longer commit message goes here. It's a really cool paragraph.

    You probably won't need a second paragraph. But it's here when you need it.
```

## Reference issues when committing
Please use the issue number within commit messages, for example `Fix #220`. This will create a link within the PR to the issue itself and help track changes. Typically, only referencing the issue is enough but if there are multiple fixes for one issue, you may add a descriptive comment when needed, for example `Fix #220 - add table numbers back to appendix`.

## Review your own code before pushing
Before you push, check your code and squash any superfluous commits, such as fast forward merge commits. 

## Comment on the issue when addressed in the PR
When the fix for an issue has been pushed to github and is ready for review, go to the issue and reference the PR in the comments. For example you may have something like `Addressed in PR #237`. This is also a good time to mention anything that the tester should be aware of or anything we may need to keep track of later on.

At this stage, the workflow is:

  - find issue `#220` on github
  - add a comment saying `Addressed in PR #237`

## Ask for peer code review 
After all commits have been pushed for your topic branch, assign `@helenemccarron` and `@philschatz` to the Reviewers section of the PR. They will also review any CI test failures. 

## Assign the PR to QA
After all reviewers have approved changes, assign the PR to the QA person who initially reported the issue(s) (Kerwin `@kerwinso` or Alan `@stackblocks`). *Note*: please use the Assignees section, not the Reviewers section.

## Dev testing
Fixes for individual issues are verified by the assigned tester in the appropriate environment. If any problems are found, the issue is updated with comments and screen captures as necessary, and reassigned to the dev that created the fix. When the issue has been verified, it is closed. Only members of the QA team should be closing issues.

## Merge
QA will merge your branch to master after they have verified the fixes addressed in that branch. Typically they will also delete the topic branch after successful merge.

