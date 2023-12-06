# Contributing to Free File

First off, thank you for considering contributing to Free File. It's people like you that make Free File such a great tool.

## Where do I go from here?

If you've noticed a bug or have a feature request, make sure to check our [Issues](https://github.com/simonpham/free_file/issues) to see if someone else in the community has already created a ticket. If not, go ahead and [make one](https://github.com/simonpham/free_file/issues/new)!

## Fork & create a branch

If this is something you think you can fix, then [fork Free File](https://help.github.com/articles/fork-a-repo) and create a branch with a descriptive name.

A good branch name would be (where issue #325 is the ticket you're working on):

```bash
git checkout -b 325-add-japanese-localisation
```

## Implement your fix or feature

At this point, you're ready to make your changes! Feel free to ask for help; everyone is a beginner at first.

## Get the style right

Your patch should follow the same conventions & pass the same code quality checks as the rest of the project.

## Make a Pull Request

At this point, you should switch back to your develop branch and make sure it's up to date with Free File's develop branch:

```bash
git remote add upstream git@github.com:simonpham/free_file.git
git checkout develop
git pull upstream develop
```

Then update your feature branch from your local copy of develop, and push it!

```bash
git checkout 325-add-japanese-localisation
git rebase develop
git push --set-upstream origin 325-add-japanese-localisation
```

Go to the [Free File repo](https://github.com/simonpham/free_file) and press the "Compare & pull request" button.

## Keeping your Pull Request updated

If a maintainer asks you to "rebase" your PR, they're saying that a lot of code has changed, and that you need to update your branch so it's easier to merge.

## Merging a PR (maintainers only)

A PR can only be merged into develop by a maintainer if:

- It is passing CI.
- It has been approved by at least two maintainers. If it was a maintainer who opened the PR, only one extra approval is needed.
- It has no requested changes.
- It is up to date with current develop.

Any maintainer is allowed to merge a PR if all of these conditions are met.

## Thank you for your contributions!

#### PS: This guide is only for reference, you can contribute in any way you want, I won't bite 🦊 
