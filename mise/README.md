# mise

[mise](https://mise.jdx.dev) manages language runtimes and CLI tools with
per-project version pinning. This package stows one file:

| Source                          | Symlinks to                                         |
| ------------------------------- | --------------------------------------------------- |
| `mise/.config/mise/config.toml` | `~/.config/mise/config.toml` (mise's global config) |

## What it's for

The global `[tools]` list is the **primary tool manager on Linux**. There is no
Homebrew on the Debian VMs (see the repo `CLAUDE.md` and `bootstrap-debian.sh`),
so `mise install` from `$HOME` is what actually installs `bat`, `eza`,
`ripgrep`, `go-task`, the Node/Go runtimes, etc. On macOS the runtimes and CLIs
still come from the `Brewfile`, but the repo's lint tools are installed via mise
there too — `bootstrap-macos.sh` stows this package and `mise install`s just
those (see the lint-tooling note below). The `[settings]` block silences mise's
"missing tool" nag for the brew-provided entries on macOS.

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
- **Repo lint tooling** — the linters `lefthook` and CI run live here so one
  file tracks them and they match CI: `shellcheck`, `shfmt`, `taplo`,
  `actionlint`, `editorconfig-checker`, `lefthook`, plus `npm:markdownlint-cli2`
  (needs node) and `pipx:yamllint` (needs python). These come from mise on macOS
  too — notably `editorconfig-checker`, whose aqua build ships the `ec` command
  lefthook/CI call (Homebrew's ships `editorconfig-checker`, no `ec`). `mdformat`
  is the one exception: its `gfm`/`tables` plugins need `pipx inject`, which
  mise's pipx backend can't express, so `task mise` install-or-upgrades it via
  `pipx`.

## How it's used

```sh
mise install     # install everything in the global config (run from anywhere)
mise upgrade     # upgrade installed tools to the latest matching the config
mise outdated    # preview which tools have newer versions (nothing changes)
mise ls          # show installed tools + versions
mise doctor      # diagnose activation / shim problems
mise use -g go@latest   # add/pin another global tool (edits this config)
```

`mise install` only fetches what's missing; `mise upgrade` re-resolves the
`latest`/`lts` pins and moves them forward. The repo root's `Taskfile.yml` has
a `task mise` target that runs `mise upgrade` and also install-or-upgrades
`mdformat` via `pipx` (see the bullet above); `task update` refreshes the vim
and nvim plugins too.

The headless `devbox` flow does this automatically: it installs `mise` from
apt, and after the dotfiles are stowed it runs `mise install` in `$HOME` with
`MISE_YES=1`.
