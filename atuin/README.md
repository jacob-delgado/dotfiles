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

| File | Stows to |
|---|---|
| `atuin/.config/atuin/config.toml` | `~/.config/atuin/config.toml` |

## Active settings

Out of 371 lines, only two are uncommented (the rest is the commented
default template):

```toml
enter_accept = true     # Enter accepts the selected history line and runs it

[sync]
records = true          # use the new record-based sync protocol
```

Everything else (themes, keymaps, filters, search behavior) is whatever
atuin defaults to.

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
