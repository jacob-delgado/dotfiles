# tmux

Stow package for `~/.tmux.conf`. Installs via `stow tmux` from the dotfiles
root. TPM auto-bootstraps on first run, so a fresh machine just needs tmux
itself.

## Table of contents

- [Quick reference](#quick-reference)
  - [Sessions, windows, panes](#sessions-windows-panes)
  - [Splits and navigation (tmux-pain-control)](#splits-and-navigation-tmux-pain-control)
  - [Copy / paste (vi mode + tmux-yank)](#copy--paste-vi-mode--tmux-yank)
  - [Session persistence (tmux-resurrect + tmux-continuum)](#session-persistence-tmux-resurrect--tmux-continuum)
  - [Misc](#misc)
- [Plugins](#plugins)
- [Fresh-machine setup](#fresh-machine-setup)

## Quick reference

Prefix is **`Ctrl+A`** (not the tmux default `Ctrl+B`). Everything below
assumes you press the prefix first.

### Sessions, windows, panes

| Keys         | Action                                                                                      |
| ------------ | ------------------------------------------------------------------------------------------- |
| `prefix + a` | Toggle to last window                                                                       |
| `prefix + c` | New window                                                                                  |
| `prefix + ,` | Rename window                                                                               |
| `prefix + s` | Session picker (built-in)                                                                   |
| `prefix + F` | fzf picker for sessions / windows / panes (tmux-fzf)                                        |
| `prefix + g` | Ripgrep+fzf popup over the current pane's directory (runs `frg`; opens result in `$EDITOR`) |
| `prefix + d` | Detach session                                                                              |
| `prefix + r` | Reload `~/.tmux.conf`                                                                       |

### Splits and navigation (tmux-pain-control)

| Keys               | Action                             |
| ------------------ | ---------------------------------- |
| \`prefix +         | \`                                 |
| `prefix + -`       | Split pane vertically (top/bottom) |
| `prefix + h/j/k/l` | Move focus left/down/up/right      |
| `prefix + H/J/K/L` | Resize pane (repeatable)           |
| `prefix + <` / `>` | Swap window with previous/next     |

### Copy / paste (vi mode + tmux-yank)

| Keys         | Action                                                        |
| ------------ | ------------------------------------------------------------- |
| `prefix + [` | Enter copy mode                                               |
| `v`          | Begin visual selection                                        |
| `y`          | Copy selection to system clipboard (pbcopy / xclip / wl-copy) |
| `q`          | Exit copy mode                                                |
| `prefix + ]` | Paste                                                         |

### Session persistence (tmux-resurrect + tmux-continuum)

| Keys              | Action                        |
| ----------------- | ----------------------------- |
| `prefix + Ctrl-s` | Save current session manually |
| `prefix + Ctrl-r` | Restore last saved session    |

Continuum also auto-saves every 15 minutes and auto-restores the last
session whenever tmux starts (`@continuum-restore 'on'`).

### Misc

| Keys                            | Action                                                               |
| ------------------------------- | -------------------------------------------------------------------- |
| `prefix + Ctrl-s` (this config) | Toggle `synchronize-panes` for the current window                    |
| Mouse                           | Enabled — click to focus panes, drag to resize, scroll to scrollback |

`SYNC` shows in the right status bar while pane sync is active.

## Plugins

Managed by [TPM](https://github.com/tmux-plugins/tpm). Install or update with
`prefix + I` (capital i) inside tmux.

| Plugin              | Purpose                                                                 |
| ------------------- | ----------------------------------------------------------------------- |
| `tmux-sensible`     | Saner defaults (history-limit, escape-time, focus-events, etc.)         |
| `tmux-pain-control` | \`                                                                      |
| `tmux-yank`         | Copy from tmux to the OS clipboard                                      |
| `tmux-resurrect`    | Save / restore tmux sessions                                            |
| `tmux-continuum`    | Auto-save every 15 min, auto-restore on tmux start                      |
| `tmux-fzf`          | `prefix + F` opens an fzf picker for sessions/windows/panes/keybindings |
| `dracula/tmux`      | Status-bar theme                                                        |

Optional plugins commented out in the config (uncomment + `prefix + I`):
`tmux-logging`, `tmux-sessionist`, `tmux-menus`, `tmux-sidebar`.

## Fresh-machine setup

```sh
# tmux must be installed (Brewfile handles macOS; apt install tmux on Debian)
stow tmux              # from the dotfiles root
tmux                   # TPM auto-clones and installs plugins on first launch
```
