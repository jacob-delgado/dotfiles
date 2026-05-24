# kitty

Stow package for `~/.config/kitty/`. [Kitty](https://sw.kovidgoyal.net/kitty/)
is the GPU-accelerated terminal — used here on macOS (`/Applications/kitty.app`,
installed via the kitty.sh installer, not Homebrew).

## Table of contents

- [Layout](#layout)
- [Main config](#main-config)
- [Dracula theme](#dracula-theme)
- [Diff colors](#diff-colors)
- [Fresh-machine setup](#fresh-machine-setup)

## Layout

| File | Stows to |
|---|---|
| `kitty/.config/kitty/kitty.conf` | `~/.config/kitty/kitty.conf` |
| `kitty/.config/kitty/dracula.conf` | `~/.config/kitty/dracula.conf` |
| `kitty/.config/kitty/diff.conf` | `~/.config/kitty/diff.conf` |

Reload after editing: `kitty @ load-config` (needs `allow_remote_control yes`),
or `Cmd+Ctrl+,` (macOS) / `Ctrl+Shift+F5` (Linux).

## Main config

`kitty.conf` pulls in the Dracula palette, sets the font, and tunes a
handful of defaults. Sections:

**Font** — `JetBrainsMono Nerd Font Mono` is the patched build with Nerd
Font glyphs (install via the `font-jetbrains-mono-nerd-font` cask, or
grab from nerdfonts.com).

**Quality of life**

| Setting | Why |
|---|---|
| `enable_audio_bell no` / `visual_bell_duration 0` | Silence the bell entirely |
| `confirm_os_window_close 0` | Don't prompt when closing a window with a running process |
| `scrollback_lines 10000` | Bigger in-memory scrollback |
| `scrollback_pager_history_size 100` | 100 MB disk-backed scrollback for the pager kitten |
| `repaint_delay 8` / `input_delay 2` / `sync_to_monitor yes` | Snappier rendering on Apple Silicon |

**macOS**

| Setting | Why |
|---|---|
| `macos_option_as_alt left` | Left-Option behaves as Alt so ⌥←/⌥→ word-jump works in shells |
| `macos_titlebar_color background` | Title bar adopts the bg color (no white strip) |
| `macos_quit_when_last_window_closed yes` | Quitting the last window quits the app |

**Remote control + shell integration**

| Setting | Why |
|---|---|
| `allow_remote_control yes` | Unlocks `kitty @ ls`, `kitty @ set-tab-title`, the ssh kitten, etc. |
| `listen_on unix:/tmp/kitty-{kitty_pid}` | Per-process control socket |
| `shell_integration enabled` | Click-to-move cursor, prompt marking, jump-by-prompt, etc. |

**Visual**

| Setting | Why |
|---|---|
| `window_padding_width 6` | Subtle gutter between text and window edge |
| `tab_bar_edge top` | Tabs on top, away from prompt output |
| `tab_bar_style powerline` + `tab_powerline_style slanted` | Curved powerline separators (uses JetBrainsMono Nerd Font glyphs) |

## Dracula theme

`dracula.conf` is the upstream palette from
<https://draculatheme.com/kitty>, unmodified. It sets:

- Foreground/background and the full ANSI palette (`color0`–`color15`)
- Cursor, selection, URL underline
- Tab bar foreground/background (active + inactive)
- Split/window border colors
- Mark colors (`kitty`'s scrollback marks feature)

Matches the rest of the dotfiles' Dracula-ish palette
([[../tig/README.md]], [[../lazygit/README.md]]).

## Diff colors

`diff.conf` styles `kitty +kitten diff` (kitty's built-in side-by-side
diff viewer) with the Dracula palette — green for added, red for removed,
purple hunk separators, cyan search, yellow selection.

Invoke with `kitty +kitten diff old new` or alias it.

## Fresh-machine setup

```sh
# kitty itself: NOT in Brewfile — installed standalone on macOS via
#   curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
# On Debian: apt install kitty (or use the same installer).

stow kitty
```
