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

One alias on top of the default config:

```yaml
aliases:
    co: pr checkout
```

`gh co <pr-number>` → `gh pr checkout <pr-number>`.

Everything else is `gh`'s default with explanatory comments preserved.

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
