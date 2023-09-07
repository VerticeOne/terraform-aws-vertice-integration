# Terraform Repository used to manage the Vertice CCO Role

This module handles linking an AWS account with your Vertice account.

## Usage
This module configures an AWS Account role to be used for integration with Vertice. If the account is your root AWS account you should configure a CUR integration, and provide the `cur_bucket_name` variable to allow access to the CUR data.

## Pre-commit

Pre-commit is a tool enabling to run specific commands as hooks on `git commit` or `git push` events. It works like the git's `pre-commit-hook` (it actually leverages it), but it is more high-level with many pre-built hooks in curated [repository](https://github.com/pre-commit).

In this repository it is used to run terraform format and syntax checks, checkov, trailing-white-space remover and [others](./.pre-commit-config.yaml).

```bash
brew install pre-commit
```

**Setup pre-commit on git push:**

Setup the `pre-commit` hook *(as `pre-push` to save time and running the check before push, not on every commit)*:

```bash
pre-commit install --hook-type pre-push
```

Optionally run `pre-commit` manually on `all files` *(on commit / push events it is run only on changed files)*:

```bash
pre-commit run --all-files
```
