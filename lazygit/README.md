# lazygit

Stow package for `~/.config/lazygit/config.yml`.

## Table of contents

- [Layout](#layout)
- [Theme](#theme)
- [Other settings](#other-settings)
- [Schema reference](#schema-reference)
- [Fresh-machine setup](#fresh-machine-setup)

## Layout

| File                                 | Stows to                       |
| ------------------------------------ | ------------------------------ |
| `lazygit/.config/lazygit/config.yml` | `~/.config/lazygit/config.yml` |

Find the live config dir on any machine with `lazygit --config-dir`.

## Theme

The official [Dracula](https://github.com/dracula/lazygit) theme (copied
verbatim from upstream), matching `git/.gitconfig`:

| Element                    | Color                  |
| -------------------------- | ---------------------- |
| activeBorderColor          | `#FF79C6` bold (pink)  |
| inactiveBorderColor        | `#BD93F9` (purple)     |
| searchingActiveBorderColor | `#8BE9FD` bold (cyan)  |
| selectedLineBgColor        | `#6272A4` (comment)    |
| optionsTextColor           | `#6272A4` (comment)    |
| unstagedChangesColor       | `#FF5555` (red)        |
| defaultFgColor             | `#F8F8F2` (foreground) |

Plus cherry-pick / marked-base-commit colors — see the file for the full
upstream block.

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

## gh integration (custom commands)

| Key | Context | Action                                                           |
| --- | ------- | ---------------------------------------------------------------- |
| `O` | global  | `gh pr view --web` — open this branch's PR in browser            |
| `C` | global  | `gh pr create --fill --web` — create PR for current branch       |
| `V` | commits | `gh pr view --web {SHA}` — open PR for selected commit           |
| `L` | global  | `gh pr list --author "@me"` — list my PRs (terminal output)      |
| `X` | global  | `gh poi` — prune branches whose PRs are merged (terminal output) |

`{{.SelectedLocalCommit.Sha}}` is lazygit's template syntax for the
selected entry in the commits panel.

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
