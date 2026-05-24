# tig

Stow package for `~/.tigrc`. `tig` is the text-mode interface for Git.

## Table of contents

- [Layout](#layout)
- [Color overrides](#color-overrides)
- [Fresh-machine setup](#fresh-machine-setup)

## Layout

| File | Stows to |
|---|---|
| `tig/.tigrc` | `~/.tigrc` |

## Color overrides

`set git-colors = no` — disable tig's reading of `git config color.*`
output (otherwise tig double-styles things that git already colored).

Custom color slots (everything else is tig's default):

| Slot | Foreground / Background |
|---|---|
| `cursor` | black on green |
| `search-result` | black on yellow |
| `line-number` | red on black |
| `title-focus` | black on yellow |
| `title-blur` | black on magenta |
| `diff-header` | yellow on default |
| `diff-index` | blue on default |
| `diff-chunk` | magenta on default |
| `"Reported-by:"` | green on default |
| `tree.date` | black on cyan (bold) |

## Fresh-machine setup

```sh
brew install tig            # in the Brewfile
stow tig
```
