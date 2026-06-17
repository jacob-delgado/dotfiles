# kitty

Stow package for `~/.config/kitty/`. [Kitty](https://sw.kovidgoyal.net/kitty/)
is the GPU-accelerated terminal — used here on macOS (`/Applications/kitty.app`,
installed via the kitty.sh installer, not Homebrew).

## Table of contents

- [Layout](#layout)
- [Main config](#main-config)
- [Windows, tabs & layouts](#windows-tabs--layouts)
- [ssh kitten](#ssh-kitten)
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

## Windows, tabs & layouts

kitty has its own multiplexing, independent of tmux. Terminology: an **OS
window** holds **tabs**; each tab arranges **windows** (splits) using a
**layout**. Every kitty shortcut uses `cmd` (macOS) or `ctrl+shift`
(`kitty_mod`, e.g. on Linux) — a different namespace from the tmux `C-a`
prefix, so the two never collide. Inside a tmux session, `cmd+…` drives kitty
and `C-a …` drives tmux; they stack happily.

Keys below are macOS (the daily driver). On Linux `cmd` is inert and kitty's
`ctrl+shift` defaults apply — see the [kitty docs](https://sw.kovidgoyal.net/kitty/overview/).

**Built-in defaults**

| Action | Key |
|---|---|
| New tab | `⌘T` |
| Next / prev tab | `⌘]` / `⌘[` (or `⌃Tab` / `⇧⌃Tab`) |
| Go to tab 1–10 | `⌘1` … `⌘9`, `⌘0` |
| Close tab | `ctrl+shift+q` |
| New OS window | `⌘N` |
| Next / prev split | `ctrl+shift+]` / `ctrl+shift+[` |
| Close split | `⌘W` |
| Next layout | `ctrl+shift+l` |
| Fullscreen toggle | `⌘↩` |

**Custom maps (this config)** — added to `kitty.conf`, macOS only. They
repurpose the default `⌘D`/`⌘⇧D` (new window) into iTerm-style directional
splits:

| Key | Action |
|---|---|
| `⌘D` | split right (`launch --location=vsplit`) |
| `⌘⇧D` | split down (`launch --location=hsplit`) |
| `⌘⌃H` / `⌘⌃J` / `⌘⌃K` / `⌘⌃L` | move focus left / down / up / right |
| `⌘R` | resize mode → then arrows or `hjkl`, `Enter`/`Esc` to finish |

These are safe alongside tmux because `cmd` never reaches the shell. The only
chord that *would* clash — `ctrl+a` (the tmux prefix) — is deliberately never
mapped in kitty.

**Layouts** — `enabled_layouts splits,stack,tall,fat,grid`, cycled with
`ctrl+shift+l`:

- **splits** — arbitrary horizontal/vertical splits; the default, and the only
  layout where the `⌘D`/`⌘⇧D` *direction* applies.
- **stack** — one split maximized (zoom); flip back with `ctrl+shift+l`.
- **tall / fat / grid** — auto-tiled arrangements for quick even layouts.

In non-`splits` layouts, `--location` is ignored and a new window is just
auto-placed by that layout.

## ssh kitten

`kitten ssh` is kitty's smarter `ssh`: it ships kitty's terminfo and shell
integration to the remote, so colors, prompt marking, and the clipboard work
there **even when kitty isn't installed on the remote** — and it can copy
selected dotfiles over. It only works when your *local* terminal is kitty
(`allow_remote_control yes` is already set above).

```sh
kitten ssh user@host          # older form: kitty +kitten ssh user@host
```

To make plain `ssh` use it automatically — only inside kitty — opt in by adding
to `zsh/.zshrc` (not enabled by default):

```sh
[[ -n $KITTY_WINDOW_ID ]] && command -v kitty >/dev/null && alias ssh='kitten ssh'
```

Per-host behavior lives in `~/.config/kitty/ssh.conf` (add it as a new file in
this package if you want it tracked):

```
# ~/.config/kitty/ssh.conf
hostname *
copy .zshrc .vimrc .config/nvim     # pushed to the remote $HOME on connect
env EDITOR=nvim
```

Caveat: wait for the shell prompt before typing on a fresh connection — early
keystrokes during the bootstrap handshake can be dropped.

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
