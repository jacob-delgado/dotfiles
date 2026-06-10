# gh

Stow package for `~/.config/gh/config.yml` only. The GitHub CLI's
companion file `hosts.yml` is deliberately **not** tracked — it carries
OAuth tokens.

## Table of contents

- [Layout](#layout)
- [Active customization](#active-customization)
- [Why hosts.yml stays out](#why-hostsyml-stays-out)
- [Schema churn warning](#schema-churn-warning)
- [Fresh-machine setup](#fresh-machine-setup)

## Layout

| File | Stows to | Tracked? |
|---|---|---|
| `gh/.config/gh/config.yml` | `~/.config/gh/config.yml` | yes |
| (`~/.config/gh/hosts.yml`) | — | no (gitignored) |

## Active customization

```yaml
prefer_editor_prompt: disabled  # prompt inline in the terminal, not in $EDITOR
pager: delta                    # syntax-highlight `gh pr diff` and similar
aliases:
    co: pr checkout
    prs: pr list --author "@me"
    prv: pr view --web
    prc: pr create --fill --web
    issues: issue list --assignee "@me"
    watch: run watch
    compare: '!gh repo view --web --branch "$(git branch --show-current)"'
```

Alias quick-ref:

| Alias | Expands to | Use |
|---|---|---|
| `gh co <#>` | `gh pr checkout <#>` | check out a PR locally |
| `gh prs` | `gh pr list --author "@me"` | list my open PRs in this repo |
| `gh prv` | `gh pr view --web` | open this branch's PR in browser |
| `gh prc` | `gh pr create --fill --web` | new PR from commits, open in browser |
| `gh issues` | `gh issue list --assignee "@me"` | issues assigned to me |
| `gh watch <run-id>` | `gh run watch <run-id>` | tail a GH Action run |
| `gh compare` | shells out — opens the GH compare view for the current branch | |

The leading `!` on `compare` is a shell-out alias; everything after runs
in a subshell.

## Extensions

Installed via `gh extension install`; they live in
`~/.local/share/gh/extensions/` (not in this repo). List with
`gh extension list`, update with `gh extension upgrade --all`.

| Extension | Command | Use |
|---|---|---|
| `dlvhdr/gh-dash` | `gh dash` | TUI dashboard of PRs/issues across repos with filters |
| `seachicken/gh-poi` | `gh poi` | prune local branches whose PRs have been merged |
| `kyanny/gh-pr-draft` | `gh pr-draft` | toggle the draft state of a PR |

Reinstall on a fresh machine:

```sh
gh extension install dlvhdr/gh-dash
gh extension install seachicken/gh-poi
gh extension install kyanny/gh-pr-draft
```

## Why hosts.yml stays out

`~/.config/gh/hosts.yml` is where gh stores per-host auth state. On
machines using token auth (Linux/CI) it contains the literal token; on
macOS gh typically uses Keychain but the file still holds the user
identity. Either way, it's per-machine state, not config, so:

- `gh/.config/gh/hosts.yml` is listed in the repo root `.gitignore`.
- The file lives at `~/.config/gh/hosts.yml` as a regular file (not a
  symlink) and `stow gh` leaves it alone.

If you ever see `hosts.yml` show up in `git status`, something has gone
wrong — investigate before committing.

## Schema churn warning

`gh` rewrites `config.yml` when new schema fields are added in a release
(it adds new commented-out entries). Expect occasional noisy diffs after
`brew upgrade gh`. Either commit the new schema or `git checkout` to
keep the previous version.

## Fresh-machine setup

```sh
brew install gh             # in the Brewfile
stow gh
gh auth login               # populates hosts.yml (which stays untracked)
```
