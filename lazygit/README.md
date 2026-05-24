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
  nerdFontsVersion: "3"   # use NF v3 glyphs (you have font-hack-nerd-font installed)
  showRandomTip: false    # silence the splash tips
```

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
