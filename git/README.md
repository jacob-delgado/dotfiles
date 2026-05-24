# git

Stow package for `~/.gitconfig`.

## Table of contents

- [Layout](#layout)
- [Local / private overrides](#local--private-overrides)
- [Delta integration](#delta-integration)
- [Dracula color scheme](#dracula-color-scheme)
- [URL aliases](#url-aliases)
- [Fresh-machine setup](#fresh-machine-setup)

## Layout

| File | Stows to |
|---|---|
| `git/.gitconfig` | `~/.gitconfig` |

## Local / private overrides

The tracked `.gitconfig` ends with:

```ini
[include]
  path = ~/.gitconfig.local
```

Anything machine-specific or sensitive (work email, signing keys, work
remotes) lives in `~/.gitconfig.local`, which is **not** stowed and not
in the repo. Create it by hand per machine.

## Delta integration

[git-delta](https://github.com/dandavison/delta) is wired in as the pager
for `git diff`, `show`, `log`, `blame`:

```ini
[core]
  pager = delta
[interactive]
  diffFilter = delta --color-only
[delta]
  navigate = true        # n / N jumps between hunks
  side-by-side = true    # split view (drop for narrow terminals)
  line-numbers = true
[merge]
  conflictstyle = zdiff3 # better 3-way conflict markers; needs git ≥ 2.35
```

`brew install git-delta` provides the binary (already in the Brewfile).

## Dracula color scheme

The `[color "*"]` sections set a Dracula-inspired palette for branches,
diffs, grep, interactive prompts, and status. Most slots are explicit;
empty values mean "use the default."

## URL aliases

```ini
[url "https://github.com/dracula/"]
  insteadOf = dracula://
```

Lets you `git clone dracula://vim` instead of typing the full URL.

## Fresh-machine setup

```sh
stow git
```

Create `~/.gitconfig.local` for any per-machine bits (work email, signing
keys, etc.) that shouldn't live in the repo.
