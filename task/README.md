# task

Stow package for [Taskwarrior](https://taskwarrior.org/) and
[taskwarrior-tui](https://github.com/kdheepak/taskwarrior-tui). Taskwarrior is
a console todo manager; taskwarrior-tui is a terminal UI on top of it. The TUI
has **no config file of its own** — it reads everything from Taskwarrior's
`taskrc`, so both tools are configured from one place here.

## Table of contents

- [Layout](#layout)
- [Config file resolution](#config-file-resolution)
- [Dracula theme](#dracula-theme)
- [Sensible defaults](#sensible-defaults)
- [taskwarrior-tui settings](#taskwarrior-tui-settings)
- [Things you might add](#things-you-might-add)
- [Verifying](#verifying)
- [Fresh-machine setup](#fresh-machine-setup)

## Layout

| File | Stows to |
|---|---|
| `task/.config/task/taskrc` | `~/.config/task/taskrc` |
| `task/.config/task/dracula.theme` | `~/.config/task/dracula.theme` |
| `task/.config/task/shortcuts/*.sh` | `~/.config/task/shortcuts/*.sh` |

Task data (the TaskChampion SQLite DB) lives at `~/.local/share/task` via
`data.location` — XDG, matching the rest of the repo. It is **not** tracked
here (it's your actual todo data).

## Config file resolution

Taskwarrior reads the first that exists, in order:

1. `rc:<path>` on the command line
2. `$TASKRC`
3. `~/.taskrc` (classic location)
4. `~/.config/task/taskrc` (XDG) ← what this package uses

Because there is no `~/.taskrc`, the XDG path wins. `include dracula.theme` in
`taskrc` is resolved relative to the `taskrc` file, so the two files must stay
side by side.

## Dracula theme

`dracula.theme` uses **named ANSI colours** (`color1`/red, `color4`/blue, …)
and palette indices, not hex. Taskwarrior maps those to the terminal's 16-colour
palette, which kitty themes with Dracula (`kitty/dracula.conf`). So the colours
render as true Dracula and stay correct on any Dracula-themed terminal —
including the Debian box. This is the same `--theme=ansi` trick `bat` uses.

The one gotcha worth remembering: in Dracula's ANSI map, **`color4` ("blue") is
purple `#bd93f9`** and **`color5` ("magenta") is pink `#ff79c6`**. The theme
leans on those for headers, projects, and recurring tasks.

Taskwarrior colours can't take hex directly (only names / `colorN` / `rgbRGB` /
`grayN`), which is the other reason the named-ANSI approach is the right call.

## Sensible defaults

Set in `taskrc`:

| Setting | Value | Why |
|---|---|---|
| `data.location` | `~/.local/share/task` | XDG, consistent with the repo |
| `news.version` | `3.4.2` | skip the interactive "task news" prompt on first run |
| `weekstart` | `monday` | week starts Monday in reports/calendar |
| `due` | `4` | colour tasks as "due" within 4 days (default is 7) |
| `nag` | *(empty)* | silence the "you have more urgent tasks" scold |
| `confirmation` | `on` | still prompt before bulk/destructive edits |
| `dateformat*` | `Y-M-D` | ISO-8601 dates on input, reports, info, annotations |

## taskwarrior-tui settings

All under the `uda.taskwarrior-tui.*` namespace in `taskrc`:

- **Behaviour** — opens on the `next` report (`status:pending`), shows the task
  detail pane (`show-info`), wraps top/bottom (`looping`), jumps to a task after
  adding it, pre-fills metadata when modifying, prompts before delete but not
  before done.
- **Cursor / marks** — `•` selection indicator (bold), `✔` for multi-selected
  rows.
- **Quick-tag** — `t` toggles the `+next` tag for fast prioritising.
- **Dracula chrome** — context bar, navbar, calendar title/today, command-line
  highlight, and the selection row all use the same named-ANSI palette as
  `dracula.theme` (e.g. active context = black on `color4`/purple).

taskwarrior-tui's movement keys are already vim-style out of the box
(`j`/`k`, `g`/`G`, `/` to filter, `:` for a command), so no key remapping is
needed. Run it with `taskwarrior-tui`, press `?` for the full key list.

### Number-key shortcuts

Press `1`–`3` in the TUI to run a one-key action on the selected (or
multi-marked) task(s). Each is a small script in `shortcuts/`, invoked with the
task UUID(s) as arguments (`rc.confirmation=off` etc. so it's a single keypress):

| Key | Script | Action |
|---|---|---|
| `1` | `snooze.sh` | `wait:tomorrow` — hide until tomorrow |
| `2` | `today.sh` | `due:today` — pull into today |
| `3` | `bump.sh` | `priority:H +next` — escalate |

Add more by dropping an executable in `shortcuts/` and pointing
`uda.taskwarrior-tui.shortcuts.N` at it (keys `1`–`9`). `~` is expanded; the
script must be `chmod +x` with a shebang.

### Shell aliases

Quick-capture aliases live in `zsh/.zshrc` (not this package, since they're
shell config): `tt`=`taskwarrior-tui`, plus `ta`/`tl`/`tn`/`td`/`tm` for
`task add`/`list`/`next`/`done`/`modify`. The OMZ `taskwarrior` plugin already
provides `t`=`task` and completion.

## Things you might add

Personal enough that they're left out by default:

```sh
# Contexts — scope every command to a project/tag set, toggle with `task context`
task context define work  +work or project:work
task context define home  -work
task context work          # activate;  task context none  to clear

# A leaner custom report
task config report.next.columns    id,start.age,priority,project,due.relative,description.count
task config report.next.labels     ID,Active,P,Project,Due,Description

# Sync (TaskChampion server / taskwarrior.org) — then set
# uda.taskwarrior-tui.background_process=sync to auto-sync from the TUI.
```

## Verifying

```sh
task rc:task/.config/task/taskrc rc.data.location=/tmp/taskcheck show >/dev/null  # parses config + theme
```

Colours and the TUI need a real Dracula-themed terminal to eyeball —
`taskwarrior-tui` can't be checked headlessly.

## Fresh-machine setup

```sh
brew install taskwarrior-tui   # in the Brewfile; pulls in task/Taskwarrior
stow task
```
