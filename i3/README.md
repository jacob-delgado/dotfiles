# i3

Stow package for i3wm and i3status configs. **Linux/X11 only** — not
stowed by default on macOS.

| Source | Target |
|---|---|
| `i3/.config/i3/config` | `~/.config/i3/config` |
| `i3/.config/i3status/config` | `~/.config/i3status/config` |

## Table of contents

- [i3wm config](#i3wm-config)
  - [Mod key](#mod-key)
  - [Navigation](#navigation)
  - [Layouts and splits](#layouts-and-splits)
  - [Workspaces](#workspaces)
  - [Multimedia / system keys](#multimedia--system-keys)
  - [Modes](#modes)
  - [Autostart](#autostart)
- [Theme (Dracula)](#theme-dracula)
- [i3status config](#i3status-config)
- [Fresh-machine setup](#fresh-machine-setup)

## i3wm config

Started from `i3-config-wizard` defaults; deviations called out below.

### Mod key

`set $mod Mod4` — i.e., the Super (Windows/Command) key. `floating_modifier
$mod` lets you Mod-drag floating windows.

### Navigation

Vim-style:

| Keys | Action |
|---|---|
| `Mod+h/j/k/l` | focus left/down/up/right |
| `Mod+Shift+h/j/k/l` | move focused window |
| `Mod+Left/Down/Up/Right` | same as above (arrow alternatives) |
| `Mod+space` | toggle focus between tiling and floating |
| `Mod+Shift+space` | toggle the focused window's floating state |
| `Mod+a` | focus parent container |

### Layouts and splits

| Keys | Action |
|---|---|
| `Mod+g` | split horizontally (next window opens to the right) |
| `Mod+v` | split vertically |
| `Mod+z` | toggle fullscreen for focused container |
| `Mod+s` / `Mod+w` / `Mod+e` | stacked / tabbed / split (toggle) layout |

`Mod+g` is the non-default — i3's wizard uses `Mod+h` for horizontal
split, which conflicts with the focus binding above. This config remaps
horizontal-split to `g`.

### Workspaces

`Mod+1..0` switch; `Mod+Shift+1..0` move the focused container to that
workspace. Standard.

| Keys | Action |
|---|---|
| `Mod+Shift+c` | reload i3 config |
| `Mod+Shift+r` | restart i3 in place (keeps session) |
| `Mod+Shift+e` | exit i3 (`i3-msg exit`) |
| `Mod+Shift+q` | kill focused window |
| `Mod+Return` | open `i3-sensible-terminal` |
| `Mod+d` | `dmenu_run` |

### Multimedia / system keys

| Key | Action |
|---|---|
| `XF86AudioLowerVolume` | `amixer set Master 8%-` |
| `XF86AudioRaiseVolume` | `amixer set Master 8%+` |
| `XF86AudioMute` | `amixer set Master toggle` |
| `XF86AudioPrev/Next/Play` | `mpc prev` / `mpc next` / `mpc_toggle` |
| `XF86MonBrightnessUp/Down` | `xbacklight -inc/-dec 10` |

(These assume ALSA + mpd + xbacklight are installed.)

### Modes

- `Mod+r` enters **resize mode** — `h/j/k/l` shrink/grow by 10px; `Enter` or
  `Esc` to exit.
- `Caps_Lock` and `Num_Lock` enter named modes solely so i3 displays a
  visual indicator on the bar when those locks are on. Pressing the same
  key again exits.

### Autostart

Run by i3 on session start:

```
exec --no-startup-id start-pulseaudio-x11
exec --no-startup-id syndaemon -t -k -i 2 -d        # disable touchpad while typing
exec --no-startup-id feh --bg-scale '/home/jacob/wallpapers/arch1080.jpg'
exec --no-startup-id unclutter -root -visible       # hide idle cursor
exec --no-startup-id dunst                          # notification daemon
exec --no-startup-id xrandr --dpi 165               # HiDPI
```

Note the hardcoded wallpaper path under `/home/jacob/` — update for the
host or replace with a relative path.

The status bar runs `i3status`:

```
bar { status_command i3status }
```

`focus_follows_mouse no` — focus only on click, not on hover.

## Theme (Dracula)

The official [Dracula](https://draculatheme.com/i3) palette, matching the
rest of the dotfiles:

- `client.*` window-border colors (focused `#6272A4`, urgent `#FF5555`,
  unfocused `#282A36`).
- `bar { colors { … } }` for the i3bar (background `#282A36`, statusline
  `#F8F8F2`, urgent `#FF5555`).
- dmenu launch colors on `Mod+d` (`-nb #282A36 -sb #6272A4 -sf #F8F8F2`).
- i3status `color_good`/`color_degraded`/`color_bad` =
  `#50FA7B`/`#F1FA8C`/`#FF5555` (see below).

## i3status config

Modules in display order:

```
wireless wlp1s0   # SSID + signal + IP
battery 0         # percentage; charging icon ⚡, discharging ⚇, full ☻
load              # 1-min load avg
cpu_usage         # %
volume master     # ALSA Master percentage
tztime local      # %I:%M%p %b %d %Y
```

Refresh interval: 5 seconds. Battery threshold for "low" warning: 10%.
Battery path is hard-coded to `/sys/class/power_supply/BAT%d/uevent`
(`%d` is replaced by the battery number).

Wireless interface is hard-coded to `wlp1s0`. Adjust per machine.

Commented-out modules: `ipv6`, disk `/`, disk `/home`, DHCP run-watch,
VPNC pidfile, VPN tun0 path-exists check.

## Fresh-machine setup

```sh
apt install i3 i3status dmenu feh dunst                # plus pulseaudio, alsa, mpd, xbacklight as needed
stow i3                                                # symlinks ~/.config/i3/ and ~/.config/i3status/
```

`bootstrap-debian.sh` does **not** stow this by default — only if the
machine actually runs an X session.
