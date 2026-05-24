# bat

Stow package for `~/.config/bat/config`. [bat](https://github.com/sharkdp/bat)
is a `cat` clone with syntax highlighting, line numbers, and git change
markers.

## Table of contents

- [Layout](#layout)
- [Settings](#settings)
- [Regenerating the default template](#regenerating-the-default-template)
- [Fresh-machine setup](#fresh-machine-setup)

## Layout

| File | Stows to |
|---|---|
| `bat/.config/bat/config` | `~/.config/bat/config` |

## Settings

```
--theme="ansi"                              # use the terminal palette (themed by p10k)
--style="numbers,changes,header"            # line numbers, git markers, file header
--pager="less -RF"                          # raw colors, quit-if-one-screen
```

`--theme="ansi"` is intentional — it picks up whatever color scheme the
terminal/Dracula gives us instead of locking to a fixed bat theme. Run
`bat --list-themes` to see alternatives.

`BAT_THEME=ansi` is also set in `zsh/.zshrc` as a belt-and-suspenders
default for tools that invoke bat via env (e.g., `MANPAGER`).

## Regenerating the default template

`bat` ships a fully commented default config:

```sh
bat --generate-config-file        # writes ~/.config/bat/config if missing
```

If you want to start over with the full template, delete the symlink and
run the above, then move the new file into `bat/.config/bat/config` and
re-stow.

## Fresh-machine setup

```sh
brew install bat        # in the Brewfile
stow bat
```
