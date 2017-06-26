# :+1::tada: Thanks for Contributing! :tada::+1:

See [openstax/CONTRIBUTING.md](https://github.com/openstax/napkin-notes/blob/master/CONTRIBUTING.md) for more information!

# Creating a Pull Request

- include a screenshot of the new stuff in the PR **description**
- link to the Ticket/Issue in the PR **description**

## Use a topic branch
*(lifted from [this](https://github.com/puppetlabs/puppet/blob/master/CONTRIBUTING.md))*

- Create a topic branch from where you want to base your work (usually the `master` branch).
- Make commits of logical units.

## Review your own code before pushing
Before you push, run `./script/test`, and check your code (squash any superfluous commits, such as fast forward merge commits).

## Give your PR a descriptive title
A title like "Resolves #234" is not very helpful because it is neither descriptive of your change set, nor does github link the issue from the PR title.

## Update the PR description with the Issue number when addressing
When the fix for an issue has been pushed to github, update the PR description to link to the Issue number. For example, you may have something like `Fixes #123`. This is also a good place to mention anything that the tester should be aware of or anything we may need to keep track of later on. If the issue is in a different repository, you can write `Fixes openstax/tutor-js#123`.

At this stage, the workflow is:

  - find your Pull Request `#234` on GitHub
  - edit the Pull Request description to say `Fixes #123`

Also, paste a link to the PR into the respective Trello card where applicable.

## Add labels to PR
If your PR does not address any open issue, or does not need to go through QA, add a **status:no-qa** label to your PR

# Creating an Issue
- include a screenshot in the Issue **description**
- if applicable, link to the PR that addresses the Issue in the **comments** (github does not create a link from the Issue to the PR, even if the PR has a link to the Issue)
- in the **comments**, mention anything that the tester should be aware of, or anything we may need to keep track of later on for this Issue

After creating the Issue:

1. In the relevant Trello card, add a Code task item with a link to the Issue. The format should look like this: `CSS https:github.com/...#123 @trellouser --- ar: ?,?`
1. Assign the relevant developer.
1. When a fix for the Issue is ready for testing, assign the relevant QA person.

# Review and QA

## Ask for peer code review
After all commits have been pushed for your topic branch, assign `@helenemccarron` and `@philschatz` to the Reviewers section of the PR. They will also review any CI test failures.

## Review code

- When reviewing the code, look at the Issue and think "what would I need to test to be confident?"
- Reads the **tests** to see if their concerns are answered. In this case it is the Styleguide link (in the :white_check_mark: next to the commit)
- Look through the diff and concerns about how the fix is implemented
- Accept/Decline the changes (using the Pull Request Review)
- If you are the last reviewer:
  - If the PR has a **status:no-qa** label, **Merge** the Pull Request
  - If there is a ticket assigned, then **Assign the PR to QA** (see below)
  - Otherwise, **Merge** the Pull Request


## Assign the PR to QA
After all reviewers have approved changes, the final reviewer will assign the PR to the QA person who initially reported the issue(s) (Kerwin `@kerwinso` or Alan `@stackblocks`). *Note*: please use the Assignees section, not the Reviewers section. If the final reviewer is lagging, the dev who originally opened the PR may either nag them or assign the PR to QA themselves (or both).

## Dev testing
Fixes for individual issues are verified by the assigned tester in the appropriate environment. If any problems are found, the issue is updated with comments and screen captures as necessary, and reassigned to the dev that created the fix. When the issue has been verified, it is closed. Typically only members of the QA team should be closing issues.

## Merge
QA will merge your branch to master after they have verified the fixes addressed in that branch. Typically they will also delete the topic branch after successful merge.

