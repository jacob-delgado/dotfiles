# lazygit

Stow package for `~/.config/lazygit/config.yml`.

## Table of contents

- [Layout](#layout)
- [Theme](#theme)
- [Other settings](#other-settings)
- [Schema reference](#schema-reference)
- [Fresh-machine setup](#fresh-machine-setup)

## Layout

| File | Stows to |
|---|---|
| `lazygit/.config/lazygit/config.yml` | `~/.config/lazygit/config.yml` |

Find the live config dir on any machine with `lazygit --config-dir`.

## Theme

Dracula-ish palette matching `git/.gitconfig`:

| Element | Color |
|---|---|
| activeBorderColor | `#bd93f9` bold (purple) |
| inactiveBorderColor | `#6272a4` (muted purple) |
| selectedLineBgColor | `#44475a` (darker purple) |
| optionsTextColor | `#8be9fd` (cyan) |

## Other settings

```yaml
gui:
  nerdFontsVersion: "3"             # use NF v3 glyphs (font-hack-nerd-font in Brewfile)
  showRandomTip: false              # silence the splash tips
  showCommandLog: false             # hide the bottom command-log panel
  showFileTree: true                # tree view in the files panel
  experimentalShowBranchHeads: true # show branch heads in the commit log

git:
  paging:
    colorArg: always
    pager: delta --paging=never     # diff pane uses delta, matching `git diff` in the terminal

os:
  editPreset: "vim"                 # `e` opens files in vim
```

The `delta` pager means lazygit's diff pane renders with the same
side-by-side, syntax-highlighted view you see from `git diff`. Both
read settings from `git/.gitconfig`'s `[delta]` block.

## Schema reference

Full options: <https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md>

Keep this file lean — lazygit can write to it when settings change via
its UI, which creates noisy diffs when you only meant to tweak one
thing.

## Fresh-machine setup

```sh
brew install lazygit       # in the Brewfile
stow lazygit
```
