# mise

[mise](https://mise.jdx.dev) manages language runtimes and CLI tools with
per-project version pinning. This package stows one file:

| Source | Symlinks to |
|---|---|
| `mise/.config/mise/config.toml` | `~/.config/mise/config.toml` (mise's global config) |

## What it's for

The global `[tools]` list is the **primary tool manager on Linux**. There is no
Homebrew on the Debian VMs (see the repo `CLAUDE.md` and `bootstrap-debian.sh`),
so `mise install` from `$HOME` is what actually installs `bat`, `eza`,
`ripgrep`, `go-task`, the Node/Go runtimes, etc. On macOS the same tools come
from the `Brewfile`; mise still activates for per-project runtime pinning, and
`mise install` works there too — it just duplicates what brew already provides.

`zsh/.zshrc` runs `mise activate zsh` **before** the tool-integration blocks
(zoxide, atuin, eza, `task`, …) so mise-managed binaries are on `PATH` when those
`command -v` checks run.

## Why these tools (and not others)

- **Runtimes** — `node` (LTS) and `go` (latest). Python is left to Debian's
  system `python3`; uncomment the pin in `config.toml` if you want mise to own
  it.
- **CLIs** — the modern replacements the shell config references. Each is gated
  behind `command -v` in `zsh/.zshrc`, so adding/removing one here never breaks
  a machine that lacks it.
- **`fzf` and `direnv` are deliberately NOT here.** Their oh-my-zsh plugins load
  during `source $ZSH/oh-my-zsh.sh`, which runs *before* `mise activate`. A
  mise-only `fzf`/`direnv` wouldn't be on `PATH` yet, so those two come from apt
  (Linux) / brew (macOS) instead.

## How it's used

```sh
mise install     # install everything in the global config (run from anywhere)
mise ls          # show installed tools + versions
mise doctor      # diagnose activation / shim problems
mise use -g go@latest   # add/pin another global tool (edits this config)
```

The headless `devbox` flow does this automatically: it installs `mise` from
apt, and after the dotfiles are stowed it runs `mise install` in `$HOME` with
`MISE_YES=1`.
