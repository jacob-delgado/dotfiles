# btop

Stow package for `~/.config/btop/btop.conf`. btop is a process / CPU /
memory / network monitor.

## Table of contents

- [Layout](#layout)
- [Settings](#settings)
- [Churn warning](#churn-warning)
- [Fresh-machine setup](#fresh-machine-setup)

## Layout

| File                          | Stows to                   |
| ----------------------------- | -------------------------- |
| `btop/.config/btop/btop.conf` | `~/.config/btop/btop.conf` |

## Settings

```ini
color_theme      = "dracula"   # matches git/, lazygit/, overall palette
theme_background = False        # transparent — inherit terminal bg
truecolor        = True         # 24-bit color (enabled by tmux too)
graph_symbol     = "braille"    # denser/prettier than block glyphs
vim_keys         = True         # hjkl navigation
```

Cycle themes inside btop with `p` (uppercase `P` reverses). Press `?`
for full keybindings. Other built-in themes worth trying:
`gruvbox_dark`, `gruvbox_dark_v2`, `gruvbox_material_dark`, `nord`,
`tokyo-night`, `tokyo-storm`.

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
