# zsh

Stow package for `~/.zshrc`. Oh My Zsh + powerlevel10k + a curated plugin set.

## Table of contents

- [Theme: powerlevel10k](#theme-powerlevel10k)
- [Plugins](#plugins)
  - [Custom plugins (conditionally loaded)](#custom-plugins-conditionally-loaded)
- [Completion](#completion)
- [PATH](#path)
- [History](#history)
- [Shell behavior](#shell-behavior)
- [Environment](#environment)
- [Tool integrations](#tool-integrations)
- [OMZ behavior](#omz-behavior)
- [What's loaded from elsewhere](#whats-loaded-from-elsewhere)

## Theme: powerlevel10k

`ZSH_THEME="powerlevel10k/powerlevel10k"`. The instant-prompt preamble is at
the top of `.zshrc` and must stay there. Configured prompt lives in
`~/.p10k.zsh` (see `p10k/` stow package); `.zshrc` sources it if present.

## Plugins

```text
aliases colored-man-pages command-not-found cp dirhistory direnv docker
extract fzf gitfast golang helm kind kube-ps1 kubectl skaffold sudo
tig tmux
```

> The OMZ `taskwarrior` plugin was deliberately **not** included: its stale
> 2022 `_task` completion errors on current zsh
> (`_task_attributes:zregexparse: invalid regex`). Taskwarrior is used only via
> its TUI (`tt`=`taskwarrior-tui`) — there are no `task`/`t` CLI aliases, and
> the bare `task` command is go-task, whose completion `.zshrc` loads instead.
> See [`task/README.md`](../task/README.md).

Highlights of non-obvious ones:

| Plugin              | Why                                                                                                   |
| ------------------- | ----------------------------------------------------------------------------------------------------- |
| `gitfast`           | Replaces `git`'s built-in completion with the official upstream Git completion — faster on big repos. |
| `command-not-found` | Suggests how to install missing commands (`apt install foo` / `brew install foo`).                    |
| `extract`           | `x file.{zip,tar.gz,7z,...}` — one command for any archive.                                           |
| `sudo`              | `Esc Esc` prepends `sudo` to the current line (or recalls the previous one with sudo).                |
| `dirhistory`        | `Alt+←/→` walks back/forward through cd history. Pairs with `AUTO_PUSHD`.                             |
| `golang`            | Adds Go aliases (`g`, `gob`, `goc`, `gor`, …) and completion.                                         |
| `kube-ps1`          | Current k8s context/namespace in the prompt.                                                          |

### Custom plugins (conditionally loaded)

Loaded only if the directory exists under `${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/`.

| Plugin                | Effect                                                                                                                         |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| `you-should-use`      | Nags when you type the long form of an alias.                                                                                  |
| `zsh-autosuggestions` | Greyed-out command completion from history; right-arrow to accept.                                                             |
| `fzf-tab`             | Replaces zsh's default completion menu with an fzf picker. **Must load last** (after every plugin that registers completions). |

Install on a fresh machine:

```sh
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions      "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
git clone --depth=1 https://github.com/Aloxaf/fzf-tab                     "$ZSH_CUSTOM/plugins/fzf-tab"
git clone --depth=1 https://github.com/MichaelAquilina/zsh-you-should-use "$ZSH_CUSTOM/plugins/you-should-use"
```

The `bootstrap-debian.sh` script does this automatically.

## Completion

Before OMZ runs `compinit`, the config prepends Homebrew completion dirs
to `FPATH` so brew-installed tools (`gh`, `lazygit`, `yq`, `stern`, etc.)
get proper tab-completion:

```sh
FPATH="$(brew --prefix)/share/zsh-completions:$(brew --prefix)/share/zsh/site-functions:$FPATH"
ZSH_DISABLE_COMPFIX=true
```

`ZSH_DISABLE_COMPFIX=true` skips OMZ's complaint about Homebrew's
group-writable `share/` directory (which is intentional on Homebrew, not
fixable without fighting brew).

The `zsh-completions` brew formula provides extra completion definitions
beyond what individual tools ship.

zstyle polish (after OMZ's compinit):

```sh
zstyle ':completion:*' menu select                          # arrow-key menu nav
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"     # colored menu
zstyle ':completion:*' rehash true                          # pick up new $PATH binaries
```

## PATH

```sh
export PATH=$PATH:$HOME/bin
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN
export PATH=$HOME/.local/bin:$PATH        # pipx / user-installed binaries
export PATH=$PATH:/usr/local/go/bin
```

`GEM_HOME` is set only if `ruby` is on PATH (guarded).

On macOS, Homebrew's GNU coreutils/findutils/sed/tar/which/grep/binutils
get prepended to PATH so GNU semantics win over the BSD defaults:

```sh
if [[ "$OSTYPE" == darwin* ]]; then
  for gnu_tool in binutils coreutils findutils gnu-sed gnu-tar gnu-which grep; do
    gnu_bin="/opt/homebrew/opt/$gnu_tool/libexec/gnubin"
    [[ "$gnu_tool" == "binutils" ]] && gnu_bin="/opt/homebrew/opt/$gnu_tool/bin"
    [[ -d "$gnu_bin" ]] && export PATH="$gnu_bin:$PATH"
  done
fi
```

## History

```ini
HISTFILE  = ~/.zsh_history
HISTSIZE  = 500000      # in-memory
SAVEHIST  = 500000      # on disk
```

Setopts beyond OMZ defaults:

- `HIST_FCNTL_LOCK`, `HIST_FIND_NO_DUPS`, `HIST_IGNORE_ALL_DUPS`,
  `HIST_LEX_WORDS`, `HIST_NO_FUNCTIONS`, `HIST_NO_STORE`,
  `HIST_REDUCE_BLANKS`, `HIST_SAVE_NO_DUPS`
- `HISTORY_IGNORE="(ls|cd|pwd|exit)"` — never store these

OMZ's defaults provide `SHARE_HISTORY`, `EXTENDED_HISTORY`,
`HIST_EXPIRE_DUPS_FIRST`, `HIST_IGNORE_SPACE`, `HIST_VERIFY` — re-affirmed
in the config for clarity.

[atuin](https://atuin.sh) replaces `Ctrl+R` with a SQLite-backed TUI on
top of this history.

## Shell behavior

```text
EXTENDED_GLOB        # ^pat (negate), ~pat (exclude), **/* (recursive)
NO_BEEP              # silence the bell
INTERACTIVE_COMMENTS # # comments allowed in interactive lines
AUTO_CD              # `dirname` alone cd's there
AUTO_PUSHD           # every cd pushes the old dir onto the stack
PUSHD_IGNORE_DUPS
PUSHD_SILENT
COMPLETE_IN_WORD     # complete from cursor position, not only end
ALWAYS_TO_END        # cursor goes to end after completion
```

## Environment

```ini
EDITOR              = vim
LANG                = en_US.UTF-8
LESS                = -RFX                                  # raw colors, quit-if-one-screen, no alt-screen
LESSHISTFILE        = -                                     # don't write ~/.lesshst
MANPAGER            = sh -c 'col -bx | bat -l man -p'       # syntax-highlighted man pages
BAT_THEME           = ansi                                  # bat respects terminal palette
RIPGREP_CONFIG_PATH = $HOME/.config/ripgrep/config          # rg won't read its config without this
```

Try `man ssh` after a fresh shell — colorized.

## Tool integrations

| Tool                    | Wiring                                                                                                                                                           |
| ----------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| zoxide                  | `eval "$(zoxide init zsh)"` (guarded on `command -v`)                                                                                                            |
| atuin                   | `eval "$(atuin init zsh)"` (guarded; replaces `Ctrl+R`)                                                                                                          |
| eza                     | when installed: `ls` is a function (falls back to real `ls` for short flag bundles with `t`, e.g. `ls -ltrh`), plus `ll`/`la`/`lt`/`ltrh` aliases                |
| git                     | curated shell shortcuts: `gst ga gaa gc gca gco gcb gd gds gp gpf glg` (names match the OMZ `git` plugin, which isn't enabled — `gitfast` gives completion only) |
| kitty                   | `kt`/`kw` rename + `kgo <title>` jump-by-name + `ktabs` listing (uses `jq`) when installed                                                                       |
| fzf                     | OMZ `fzf` plugin auto-sources `~/.fzf.zsh` (see `fzf/`)                                                                                                          |
| zsh-syntax-highlighting | sourced at the end; tries Linux, Apple Silicon brew, Intel brew paths in order                                                                                   |

## OMZ behavior

```text
zstyle ':omz:update' mode reminder   # prompt when updates are available
zstyle ':omz:update' frequency 14    # check every 2 weeks
DISABLE_UNTRACKED_FILES_DIRTY=true   # faster git status in big repos
COMPLETION_WAITING_DOTS=true
```

## What's loaded from elsewhere

- `~/.fzf.zsh` (auto-sourced by OMZ `fzf` plugin) — fzf options + the
  `frg` ripgrep+fzf function. See `fzf/README.md`.
- `~/.p10k.zsh` — prompt configuration. See `p10k/README.md`.
