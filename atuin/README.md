# atuin

Stow package for `~/.config/atuin/config.toml`. [Atuin](https://atuin.sh)
is a SQLite-backed shell history with full-text search, per-directory
context, and optional E2E-encrypted sync.

## Table of contents

- [Layout](#layout)
- [Active settings](#active-settings)
- [Why the file is so long](#why-the-file-is-so-long)
- [Regenerating](#regenerating)
- [Fresh-machine setup](#fresh-machine-setup)

## Layout

| File                              | Stows to                      |
| --------------------------------- | ----------------------------- |
| `atuin/.config/atuin/config.toml` | `~/.config/atuin/config.toml` |

## Active settings

```toml
enter_accept = true       # Enter runs the selected line immediately
search_mode  = "fuzzy"    # fuzzy match (explicit; matches modern default)
filter_mode  = "global"   # Ctrl+R searches across all sessions/hosts
workspaces   = true       # treat git repos as a scope for filter_mode = "workspace"
style        = "compact"  # denser TUI layout

[sync]
records = true            # newer record-based sync protocol
```

The rest of the file is atuin's commented default template, kept around
as a cheat-sheet of tunable options.

**`enter_accept = true` gotcha:** the default behavior is Enter inserts
the line for editing, Tab runs it. This config flips them so Enter runs
the selection immediately — faster but easier to misfire on a dangerous
command. Flip back if that bites you.

## Why the file is so long

When atuin first generates `config.toml` it writes the entire schema
with every option commented out. We keep the full file rather than
trimming to the two active lines so the comments stay around as a
cheat-sheet for what's tunable.

## Regenerating

If you change settings via the atuin TUI (some are configurable there),
atuin rewrites this file. Diff it against the tracked version:

```sh
git -C ~/dotfiles diff atuin/.config/atuin/config.toml
git -C ~/dotfiles commit -am "Update atuin config"
```

If atuin's config schema gains new fields in a future release, you may
see a flood of diff noise from the new commented entries — review and
commit if you want the updated template.

## Fresh-machine setup

```sh
brew install atuin          # in the Brewfile
stow atuin
atuin import auto           # one-time: backfill existing zsh history into atuin's DB
```

Run `atuin register` if you want sync across machines; otherwise
everything stays local.

`zsh/.zshrc` initializes atuin via `eval "$(atuin init zsh)"`.
