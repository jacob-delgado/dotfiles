# Xresources

Stow package for `~/.Xresources`. **Linux/X11 only** — used by URxvt,
xterm, and other X11 apps that read the resource database.

## Table of contents

- [Palette: Wombat](#palette-wombat)
- [URxvt](#urxvt)
- [xterm](#xterm)
- [Xft (font rendering)](#xft-font-rendering)
- [Activating changes](#activating-changes)
- [Fresh-machine setup](#fresh-machine-setup)

## Palette: Wombat

A dark-background terminal palette derived from the Wombat color scheme.

| Slot | Color |
|---|---|
| `*background` | `#161616` (near-black) |
| `*foreground` | `#ffffff` |
| `color0..7` | normal palette (black, red, green, yellow, blue, magenta, cyan, white) |
| `color8..15` | bright palette |

Defined as full `*colorN: rgb:RR/GG/BB` entries so they apply to any X
client reading the resource database, not just URxvt.

## URxvt

Non-default settings:

| Resource | Value | Why |
|---|---|---|
| `URxvt*font` / `boldFont` | `xft:Consolas:size=12` | Consolas-based; needs MS fonts installed |
| `URxvt*depth` | `32` | enable ARGB visuals (real transparency) |
| `URxvt*transparent` | `true` + `shading: 10` | translucent terminal |
| `URxvt*buffered` | `true` | double-buffered redraw |
| `URxvt*cursorBlink` | `true` |  |
| `URxvt*saveLines` | `65535` | large scrollback |
| `URxvt*scrollBar` | `false` |  |
| `URxvt*scrollTtyOutput` | `false` | don't jump on program output |
| `URxvt*scrollTtyKeypress` | `true` | jump on keypress |
| `URxvt*scrollWithBuffer` | `true` | scrollback follows new lines while at the bottom |
| `URxvt*secondaryScreen` | `true` + `secondaryScroll: false` | alt-screen apps don't pollute scrollback |
| `URxvt*loginShell` | `true` | spawn as a login shell |
| `URxvt*inheritPixmap` | `true` | inherit root pixmap (for true transparency vs. shading) |

## xterm

Lighter touch — xterm is mostly used as a fallback.

| Resource | Value |
|---|---|
| `xterm*faceName` | `Consolas:style=Regular:size=12` |
| `xterm*loginShell` | `true` |
| `xterm*saveLines` | `65535` |
| `xterm*charClass` | custom word-class string so double-click selects URLs and paths |
| `xterm*boldMode` | `false` |
| `xterm*eightBitInput` | `false` (so `Alt` doesn't get encoded) |

## Xft (font rendering)

```
Xft.antialias:  true
Xft.autohint:   false
Xft.dpi:        92
Xft.hinting:    true
Xft.hintstyle:  hintslight
Xft.lcdfilter:  lcddefault
Xft.rgba:       rgb
```

The DPI is hard-coded to 92 here, but `i3/.config/i3/config` runs
`xrandr --dpi 165` on autostart, which can override. Reconcile per host
if you care.

## Activating changes

```sh
xrdb -merge ~/.Xresources       # apply without restarting X
# or
xrdb ~/.Xresources              # replace the database wholesale
```

Already-running terminals won't pick up changes until restart.

## Fresh-machine setup

```sh
apt install rxvt-unicode-256color   # for URxvt; xterm ships with most X installs
stow Xresources                     # symlinks ~/.Xresources
xrdb -merge ~/.Xresources
```

Not stowed by default by `bootstrap-debian.sh` — only relevant on
graphical Linux machines.
