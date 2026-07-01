# dotfiles

[![View on GitHub](https://img.shields.io/badge/GitHub-jacob--delgado%2Fdotfiles-181717?logo=github)](https://github.com/jacob-delgado/dotfiles)

Personal dotfiles, managed with [stow](https://www.gnu.org/software/stow/).
Each top-level directory is a stow package mirroring the layout it should have
under `$HOME` (e.g. `stow zsh` symlinks `zsh/.zshrc` to `~/.zshrc`).

A `Brewfile` at the repo root pins the Homebrew packages I rely on; run
`brew bundle` from this directory to install everything.

Browsable docs (one page per package, auto-generated from each subdir's
README): <https://jacob-delgado.github.io/dotfiles/>.

## Table of contents

- [Apply pending changes](#apply-pending-changes)
- [Subdirectories](#subdirectories)
- [Modern CLI tools](#modern-cli-tools) — zoxide, atuin, eza, git-delta, yq, kubectx, stern, lazygit, dust, btop, watchexec, hyperfine, tldr
- [Installing on a new machine](#installing-on-a-new-machine)
  - [Debian / Ubuntu](#debian--ubuntu)
  - [macOS / manual](#macos--manual)
  - [Oh My Zsh custom plugins](#oh-my-zsh-custom-plugins)

## Apply pending changes

Manual steps to activate recent edits on this machine (config is
committed; these are the local actions to make each take effect). Tick
off and prune as you go.

- [ ] **Open a new shell** (`exec zsh`) — activates the fzf Dracula
  colors, the git shell aliases (`gst`/`gco`/…), the eza `ls` function +
  `ltrh`, the `~/.local/bin` PATH, and the p10k rainbow+Dracula prompt
  (best viewed in a kitty terminal).
- [ ] **vim** — install the plugin set (`~/.vim/plugged` may be empty):
  ```sh
  vim +"PlugInstall --sync" +qall
  ```
  Covers `vim-snippets`, `vim-unimpaired`, `vim-eunuch`; molokai was
  dropped, so nothing to clean. Open a `.go` file to confirm dracula.
- [ ] **nvim** *(new package — vim stays the default `$EDITOR`)* — stow,
  then install plugins headlessly:
  ```sh
  stow nvim
  nvim --headless "+Lazy! sync" +qa
  ```
  Treesitter compiles parsers on first run (needs a C compiler). For the
  optional Go tools, open a `.go` file and run `:GoInstallBinaries` (go.nvim is
  filetype-loaded, so it isn't available on an empty buffer). Commit the
  generated `nvim/.config/nvim/lazy-lock.json` to pin plugin versions. See
  [nvim/README.md](nvim/README.md).
- [ ] **lazygit** — restart `lazygit` and eyeball the official theme.
- **ripgrep / gh** — no action needed; apply on next invocation.

> On a **fresh machine**, also recreate `~/.gitconfig.local` (untracked)
> with the gh credential helper — see [git/README.md](git/README.md).

## Subdirectories

Each is a stow package; see its README for what's non-default.

| Package | Stows to | README |
|---|---|---|
| `atuin/` | `~/.config/atuin/config.toml` | [atuin/README.md](atuin/README.md) |
| `bat/` | `~/.config/bat/` | [bat/README.md](bat/README.md) |
| `btop/` | `~/.config/btop/` | [btop/README.md](btop/README.md) |
| `direnv/` | `~/.config/direnv/` | [direnv/README.md](direnv/README.md) |
| `editorconfig/` | `~/.editorconfig` | [editorconfig/README.md](editorconfig/README.md) |
| `fzf/` | `~/.fzf.zsh` | [fzf/README.md](fzf/README.md) |
| `gh/` | `~/.config/gh/config.yml` | [gh/README.md](gh/README.md) |
| `git/` | `~/.gitconfig` | [git/README.md](git/README.md) |
| `gitignore_global/` | `~/.gitignore_global` | [gitignore_global/README.md](gitignore_global/README.md) |
| `hadolint/` | `~/.config/hadolint/` | [hadolint/README.md](hadolint/README.md) |
| `lazygit/` | `~/.config/lazygit/` | [lazygit/README.md](lazygit/README.md) |
| `lefthook/` | (template, not stowed) | [lefthook/README.md](lefthook/README.md) |
| `mise/` | `~/.config/mise/config.toml` | [mise/README.md](mise/README.md) |
| `nvim/` | `~/.config/nvim/` | [nvim/README.md](nvim/README.md) |
| `p10k/` | `~/.p10k.zsh` | [p10k/README.md](p10k/README.md) |
| `ripgrep/` | `~/.config/ripgrep/` | [ripgrep/README.md](ripgrep/README.md) |
| `shellcheck/` | `~/.shellcheckrc` | [shellcheck/README.md](shellcheck/README.md) |
| `task/` | `~/.config/task/` | [task/README.md](task/README.md) |
| `tig/` | `~/.tigrc` | [tig/README.md](tig/README.md) |
| `tmux/` | `~/.tmux.conf` | [tmux/README.md](tmux/README.md) |
| `vim/` | `~/.vimrc`, `~/.vim/` | [vim/README.md](vim/README.md) |
| `yamllint/` | `~/.config/yamllint/` | [yamllint/README.md](yamllint/README.md) |
| `zsh/` | `~/.zshrc` | [zsh/README.md](zsh/README.md) |

Conventions for the whole repo: [CLAUDE.md](CLAUDE.md).

---

## Modern CLI tools

The tools below are the recent additions on top of the standard
fzf/bat/fd/ripgrep set. Each section covers what it does, the everyday
usage, and any extra configuration needed.

### zoxide — smarter `cd`

A `cd` replacement that remembers directories you visit and jumps to them by
substring.

```sh
z dotfiles        # jump to the most-recent dir matching "dotfiles"
z dot files       # multi-keyword: match dirs scoring on both
zi                # interactive fzf picker over your history
```

**Config:** `eval "$(zoxide init zsh)"` (already wired up in `zsh/.zshrc`).
The init hook is what records every `cd`.

### atuin — supercharged shell history

SQLite-backed history with full-text search, per-directory context, and
optional E2E-encrypted sync across machines. Replaces `Ctrl+R`.

```sh
atuin import auto         # one-time import of existing zsh history
atuin search kubectl      # CLI search
atuin stats               # top commands, busiest hours, etc.
# Ctrl+R opens the atuin TUI; Up arrow keeps prefix-search behavior
```

**Config:** `eval "$(atuin init zsh)"` (already wired up). Run
`atuin register` if you want sync; otherwise everything stays local.

### eza — modern `ls`

Coloured `ls` with git status, tree view, and saner defaults.

```sh
ls                # alias -> eza
ll                # eza -l --git --group-directories-first
la                # ll + hidden
lt                # tree view, depth 2, respects .gitignore
```

**Config:** aliases live in `zsh/.zshrc` and are only set when `eza` is on
PATH, so other machines aren't broken by their absence.

### git-delta — beautiful git diffs

Pager that renders git diff/show/log/blame with syntax highlighting and
optional side-by-side view.

```sh
git diff          # now uses delta
git show HEAD
git log -p
```

**Config:** delta is installed but not yet wired into git. Add to
`~/.gitconfig`:

```ini
[core]
    pager = delta
[interactive]
    diffFilter = delta --color-only
[delta]
    navigate = true        # n / N jump between hunks
    side-by-side = true
    line-numbers = true
[merge]
    conflictstyle = zdiff3
```

### yq — `jq` for YAML

Same query language as jq, applied to YAML (and TOML, XML, etc.). Essential
for k8s manifests and helm values.

```sh
yq '.spec.template.spec.containers[].image' deploy.yaml
yq -i '.image.tag = "v1.2.3"' values.yaml          # in-place edit
kubectl get pod foo -o yaml | yq '.status.conditions'
```

**Config:** none.

### kubectx + kubens — fast cluster/namespace switching

Bundled together in the `kubectx` formula. Pairs with `kube-ps1` so your
prompt always shows the current target.

```sh
kubectx                  # list contexts, current marked
kubectx prod             # switch to "prod"
kubectx -                # toggle back to previous
kubens kube-system       # switch namespace in current context
kubens -                 # toggle previous namespace
```

If `fzf` is on PATH the bare `kubectx`/`kubens` commands become interactive
pickers. **Config:** none.

### stern — multi-pod log tailing

Tails logs across pods matching a label/selector/name regex with colour-coded
output per pod. Vastly nicer than `kubectl logs -f` for anything multi-replica.

```sh
stern api                       # tail every pod whose name matches "api"
stern -l app=api --tail 100     # last 100 lines, then follow
stern api --since 5m
stern api -n staging
```

**Config:** none. Completions auto-load via oh-my-zsh's `kubectl` plugin.

### lazygit — TUI git client

Interactive terminal UI for staging hunks, rebasing, cherry-picking, branch
ops. Complements `tig` (which is read-focused for log/blame).

```sh
lazygit                  # launch in current repo
```

Inside: `space` stage, `c` commit, `P` push, `p` pull, `r` rebase menu,
`?` for keybindings. **Config:** none required; per-user settings live at
`~/.config/lazygit/config.yml` if you want to customize.

### dust — visual `du`

Sorted, colourised disk usage breakdown that's easier to scan than
`du -sh *`.

```sh
dust                     # current dir
dust -d 3 ~/dotfiles     # depth 3
dust -r                  # reverse (largest at bottom)
```

**Config:** none.

### btop — modern `top`/`htop`

Process / CPU / memory / network monitor with mouse support and themes.

```sh
btop
```

Press `q` to quit, `m` for memory view, `p` to cycle themes. **Config:**
none; per-user config at `~/.config/btop/btop.conf`.

### watchexec — re-run on file changes

Generic file watcher. Drop-in for ad-hoc dev loops without writing Makefile
glue.

```sh
watchexec -- go test ./...
watchexec -e go,proto -- make build         # only .go and .proto
watchexec --restart -- ./server             # restart long-running process
```

**Config:** none.

### hyperfine — command benchmarking

Statistically rigorous timing of CLI commands with warmup, multiple runs,
and comparisons.

```sh
hyperfine 'fd .' 'find .'
hyperfine --warmup 3 './build.sh'
hyperfine -n new -n old 'cmd-v2' 'cmd-v1' --export-markdown bench.md
```

**Config:** none.

### tealdeer (tldr) — example-driven cheat sheets

Crowdsourced quick-reference pages — usually faster than `man` when you just
need example invocations.

```sh
tldr --update            # one-time: fetch the pages cache
tldr tar
tldr git rebase
```

**Config:** none.

---

## Installing on a new machine

### Debian / Ubuntu

```sh
git clone <this-repo> ~/dotfiles
cd ~/dotfiles
./bootstrap-debian.sh          # apt + Linuxbrew + OMZ + plugins + stow
```

Idempotent — safe to re-run.

### macOS / manual

```sh
git clone <this-repo> ~/dotfiles
cd ~/dotfiles
brew bundle                    # installs everything in Brewfile
stow zsh vim tmux fzf          # symlink whichever packages you want
```

### Oh My Zsh custom plugins

The `.zshrc` conditionally loads these third-party plugins if their
directories exist under `${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/`.
Install with:

```sh
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions      "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
git clone --depth=1 https://github.com/Aloxaf/fzf-tab                     "$ZSH_CUSTOM/plugins/fzf-tab"
git clone --depth=1 https://github.com/MichaelAquilina/zsh-you-should-use "$ZSH_CUSTOM/plugins/you-should-use"
```

What they do:

- **zsh-autosuggestions** — suggests the rest of a command in grey as you
  type, based on history. Right-arrow accepts.
- **fzf-tab** — replaces zsh's default completion menu with an fzf picker
  with preview. Tab → interactive list.
- **you-should-use** — reminds you when you typed the long form of a
  command you've aliased.
