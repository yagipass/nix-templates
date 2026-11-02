# Contributing

## Setup

Run `nix develop` (or `direnv allow`) in the repository root. It installs the git hooks, which run treefmt (nixfmt), deadnix, and statix on staged files.

## Build and test

The root flake holds the tooling and lists the templates. Each `java*-maven` directory is a flake of its own, with its own `flake.lock`.

| Command | Purpose |
|---|---|
| `nix fmt` | format Nix |
| `nix flake check .` | check the formatting, run the git hooks over every tracked file, and check the template definitions, as CI does |
| `nix flake check ./java21-maven` | evaluate one template, as CI does for each |
| `nix develop ./java21-maven --command true` | build one template's dev shell, as CI does for each |

CI runs on Linux x86_64 only and does not run the `pg-*` commands, so after changing them, try them in a dev shell.

## Rules

- The `flake.nix` files of the `java*-maven` templates differ only in the Java version. Apply a change to all of them.
- After adding or updating an action in a workflow, run [`gh actions-lock`](https://github.com/github/gh-actions-lock).
- Commit messages follow Conventional Commits.
- Name branches `<type>/<slug>` after the Conventional Commits type.

## Adding a template

1. Copy a `java*-maven` directory, change the Java version in its `flake.nix`, and `git add` it. Nix sees only files tracked by git.
2. Add it to `flake.templates` in the root `flake.nix` and to the table in `README.md`.

The workflows find templates by the directory pattern `java*-maven`. A template with another name also needs changes to `ci.yml` and `update-flake-lock.yml`.

## Proposing a change

Open an issue before you start on a new template or a change in behavior, with the project setup you want it to support. A small fix, such as a typo, can go straight to a pull request. Report a vulnerability as [SECURITY.md](SECURITY.md) describes, not in an issue.

A pull request:

- references its issue (`Closes #N`), if it has one.
- passes the checks above.
- has a Conventional Commits title. Pull requests are squash-merged, so the title becomes the commit on `main`.

## Updates

There are no releases. Projects copy a template from `main` with `nix flake init`.

`update-flake-lock.yml` opens two pull requests every Monday, one that updates the locks of the templates and one that updates the root lock. Dependabot updates the GitHub Actions.

## Repository settings

The repository settings, labels, rulesets, and Actions permissions are managed with [gh-infra](https://github.com/babarot/gh-infra) in `.github/infra.yml`. To change them, edit the file, review the difference with `gh infra plan .github/infra.yml`, and apply it with `gh infra apply .github/infra.yml`. Applying needs admin access to the repository.

Renaming the `check` job in `ci.yml` also needs the same change under `required_status_checks`, or pull requests cannot merge.
