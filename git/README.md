# git

Stow package for `~/.gitconfig`.

## Table of contents

- [Layout](#layout)
- [Local / private overrides](#local--private-overrides)
- [Delta integration](#delta-integration)
- [Behavior tuning](#behavior-tuning)
- [Aliases](#aliases)
- [Dracula color scheme](#dracula-color-scheme)
- [URL aliases](#url-aliases)
- [Companion tools](#companion-tools)
- [Fresh-machine setup](#fresh-machine-setup)

## Layout

| File             | Stows to       |
| ---------------- | -------------- |
| `git/.gitconfig` | `~/.gitconfig` |

## Local / private overrides

The tracked `.gitconfig` ends with:

```ini
[include]
  path = ~/.gitconfig.local
```

Anything machine-specific or sensitive (work email, signing keys, work
remotes, credential helpers) lives in `~/.gitconfig.local`, which is
**not** stowed and not in the repo. Create it by hand per machine.

For example, `gh auth setup-git` writes a `[credential]` helper with a
host-specific path (`/opt/homebrew/bin/gh` on macOS) — that belongs here,
not in the tracked `.gitconfig`.

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

## Behavior tuning

```ini
[init]    defaultBranch = main
[pull]    rebase = true; ff = only             # rebase on pull, error on divergence
[push]    default = current; autoSetupRemote = true; followTags = true
[fetch]   prune = true                          # drop refs to deleted remote branches
[rebase]  autosquash = true; autoStash = true   # fixup! commits flow; uncommitted work stashes
[diff]    algorithm = histogram; colorMoved = default; renames = copies
[rerere]  enabled = true                        # remember conflict resolutions
```

These set sane defaults for git's nagging warnings (divergent branches,
missing upstream) and unlock features that aren't on by default but
should be (`rerere`, histogram diff, move-block detection).

## Aliases

| Alias                 | Expands to                                                  | Use                                              |
| --------------------- | ----------------------------------------------------------- | ------------------------------------------------ |
| `git st`              | `status -sb`                                                | short status with branch line                    |
| `git co`              | `checkout`                                                  |                                                  |
| `git br`              | `branch`                                                    |                                                  |
| `git cm`              | `commit`                                                    |                                                  |
| `git ca`              | `commit --amend`                                            |                                                  |
| `git cane`            | `commit --amend --no-edit`                                  | amend without re-editing the message             |
| `git lg`              | pretty-graph log                                            | one-line graph with colors and `ago`-style dates |
| `git last`            | `log -1 HEAD --stat`                                        | what did the last commit touch?                  |
| `git staged`          | `diff --cached`                                             | review what's about to be committed              |
| `git unstage`         | `reset HEAD --`                                             | undo `git add`                                   |
| `git undo`            | `reset --soft HEAD^`                                        | un-commit (keeping changes)                      |
| `git wip`             | `add -A && commit -m 'WIP'`                                 | snapshot to step away                            |
| `git prune-branches`  | delete every merged branch (except current / main / master) | safe local cleanup                               |
| `git cp`              | `cherry-pick`                                               |                                                  |
| `git sw` / `git swc`  | `switch` / `switch -c`                                      | modern branch switch / create                    |
| `git cob`             | `checkout -b`                                               | create + switch (older style)                    |
| `git aa` / `git ap`   | `add -A` / `add -p`                                         | stage all / interactively by hunk                |
| `git fa`              | `fetch --all --prune`                                       | refresh all remotes, drop stale branches         |
| `git pf`              | `push --force-with-lease`                                   | safe force-push (won't clobber others' work)     |
| `git rbi`             | `rebase -i --autosquash`                                    | interactive rebase, auto-orders fixups           |
| `git rbc` / `git rba` | `rebase --continue` / `--abort`                             |                                                  |
| `git fixup`           | `commit --fixup <sha>`                                      | marks a fixup commit for `rbi` to squash         |
| `git recent`          | last 10 branches by commit date                             |                                                  |
| `git root`            | `rev-parse --show-toplevel`                                 | print the repo root                              |
| `git aliases`         | list every configured alias                                 |                                                  |

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

## Companion tools

Installed via Brewfile, no extra config required:

| Tool             | Use                                                                                                                                                                                                                           |
| ---------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `git-delta`      | pager (wired in above)                                                                                                                                                                                                        |
| `git-absorb`     | `git absorb` — auto-creates `fixup!` commits targeting the right earlier commit based on what lines your unstaged changes touch. Pair with `git rebase -i --autosquash` (which `[rebase] autosquash = true` runs by default). |
| `git-branchless` | adds porcelain inspired by Mercurial/Sapling: `git smartlog`, `git move`, `git restack`, `git undo` (cross-operation undo). Power-user; read `git help branchless` first.                                                     |

## Fresh-machine setup

```sh
stow git
```

Create `~/.gitconfig.local` for any per-machine bits (work email, signing
keys, etc.) that shouldn't live in the repo. `git-delta`, `git-absorb`,
and `git-branchless` come in via the Brewfile.
