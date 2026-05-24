# btop

Stow package for `~/.config/btop/btop.conf`. btop is a process / CPU /
memory / network monitor.

## Table of contents

- [Layout](#layout)
- [Settings](#settings)
- [Churn warning](#churn-warning)
- [Fresh-machine setup](#fresh-machine-setup)

## Layout

| File | Stows to |
|---|---|
| `btop/.config/btop/btop.conf` | `~/.config/btop/btop.conf` |

## Settings

```
color_theme = "TTY"     # low-contrast, terminal-palette-friendly
vim_keys = True         # hjkl navigation
truecolor = True        # use 24-bit color when the terminal supports it
update_ms = 2000        # refresh every 2 seconds
proc_tree = False       # flat process list by default
```

Cycle themes inside btop with `p` (uppercase `P` reverses). Press `?`
for full keybindings.

## Churn warning

btop **rewrites** this file every time you change a setting via its TUI
(theme cycling, sort order, etc.). Diff before committing:

```sh
git -C ~/dotfiles diff btop/.config/btop/btop.conf
```

## Fresh-machine setup

```sh
brew install btop      # in the Brewfile
stow btop
```
