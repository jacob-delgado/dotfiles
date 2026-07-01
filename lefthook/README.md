# lefthook

Per-project git-hooks manager template. **Lefthook has no global config**
— this directory ships a `lefthook.yml` you can copy or `extends:` into
new repos.

## Table of contents

- [Layout](#layout)
- [Two ways to use it](#two-ways-to-use-it)
- [What the template runs](#what-the-template-runs)
- [Adding repo-specific hooks](#adding-repo-specific-hooks)
- [Skipping a hook](#skipping-a-hook)
- [Fresh-machine setup](#fresh-machine-setup)

## Layout

| File                    | Purpose                               |
| ----------------------- | ------------------------------------- |
| `lefthook/lefthook.yml` | Go-dev baseline template (no symlink) |

This package is **not** stowed — lefthook.yml is meant to live inside
your project repos, not in `$HOME`.

## Two ways to use it

### 1. Copy into a new repo

```sh
cp ~/dotfiles/lefthook/lefthook.yml ./lefthook.yml
lefthook install
```

`lefthook install` writes the `.git/hooks/*` shims that invoke lefthook.
You only need to do this once per clone.

### 2. Extend it from your project's lefthook.yml

```yaml
# project/lefthook.yml
extends: ~/dotfiles/lefthook/lefthook.yml

pre-commit:
  commands:
    # project-specific addition
    api-spec-check:
      glob: "openapi.yaml"
      run: spectral lint {staged_files}
```

Then `lefthook install` and additions stack on top of the baseline.

## What the template runs

**pre-commit** (parallel):

| Hook            | Glob           | What                                            |
| --------------- | -------------- | ----------------------------------------------- |
| `gofmt`         | `*.go`         | fail if any file isn't gofmt'd                  |
| `goimports`     | `*.go`         | fail if imports aren't sorted                   |
| `golangci-lint` | `*.go`         | run lint, only new findings since HEAD          |
| `govet`         | `*.go`         | `go vet ./...`                                  |
| `shellcheck`    | `*.{sh,bash}`  | lint staged shell                               |
| `shfmt`         | `*.{sh,bash}`  | format-diff shell (2-space, switch-case indent) |
| `yamllint`      | `*.{yml,yaml}` | YAML lint                                       |
| `hadolint`      | `Dockerfile*`  | Dockerfile lint                                 |

**commit-msg**: reject empty subjects.

**pre-push** (parallel):

| Hook       | Glob   | What             |
| ---------- | ------ | ---------------- |
| `go-test`  | `*.go` | `go test ./...`  |
| `go-build` | `*.go` | `go build ./...` |

All the linters / formatters are in the Brewfile.

## Adding repo-specific hooks

The most common pattern: `extends:` the baseline, then add or override.
Anything you add lives in the project repo (versioned with the code).

## Skipping a hook

```sh
LEFTHOOK_EXCLUDE=golangci-lint git commit -m "wip"
# or skip all hooks (use sparingly):
git commit --no-verify
```

## Fresh-machine setup

```sh
brew install lefthook   # in the Brewfile
# In each repo where you want hooks:
lefthook install
```
