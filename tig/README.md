# tig

Stow package for `~/.tigrc`. `tig` is the text-mode interface for Git —
the read/navigate companion to lazygit's interactive UI.

## Table of contents

- [Layout](#layout)
- [Display options](#display-options)
- [Color scheme](#color-scheme)
- [Key bindings](#key-bindings)
- [Fresh-machine setup](#fresh-machine-setup)

## Layout

| File         | Stows to   |
| ------------ | ---------- |
| `tig/.tigrc` | `~/.tigrc` |

## Display options

```text
set git-colors    = no                 # don't double-style on top of git's color.* output
set diff-options  = -m --first-parent  # render merges as patches; follow first parent only
set show-changes  = yes                # staged/unstaged appear as faux commits in main view
set blame-options = -C -C -C           # `tig blame` follows copies across files
set wrap-lines    = yes                # wrap long lines instead of clipping
```

`show-changes = yes` is especially nice: in the main commit view, the
top entries show your current `HEAD` state with unstaged + staged
changes — no need to bounce back to `git status`.

## Color scheme

Dracula-ish, using ANSI color slots (named colors) rather than hex.
Each terminal's Dracula theme maps the ANSI palette consistently
(magenta → pink, blue → comment-purple, etc.), so the same `.tigrc`
renders right on macOS iTerm/Terminal.app and Linux URxvt/Wezterm
without per-platform tweaks.

| Element                                     | Color                         |
| ------------------------------------------- | ----------------------------- |
| Selected line (cursor)                      | bold magenta (pink)           |
| Search results                              | black on yellow               |
| Line numbers                                | blue (comment-purple), subtle |
| Active pane title                           | bold magenta on black         |
| Inactive pane title                         | blue on black                 |
| diff +/- bodies                             | green / red                   |
| diff +/- highlight                          | inverse green / red           |
| Commit headers                              | bold yellow                   |
| Index lines                                 | cyan                          |
| Hunk markers                                | magenta                       |
| Author column                               | cyan                          |
| Date column                                 | blue (comment-purple)         |
| HEAD marker                                 | bold magenta                  |
| Tags                                        | bold yellow                   |
| Remote refs                                 | green                         |
| Trailers (`Reported-by:`, `Signed-off-by:`) | green                         |

## Key bindings

| Key | Action                                                                                                  |
| --- | ------------------------------------------------------------------------------------------------------- |
| `Y` | Copy the selected commit SHA to the system clipboard (pbcopy / xclip / wl-copy, whichever is available) |

All of tig's built-in bindings (`Enter` view commit, `R` refresh, `q`
quit, `?` help, etc.) remain unchanged.

## Fresh-machine setup

```sh
brew install tig            # in the Brewfile
stow tig
```
