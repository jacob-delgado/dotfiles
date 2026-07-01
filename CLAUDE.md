# CLAUDE.md

Project-wide conventions for this dotfiles repo. Applies anywhere unless a
subdirectory has its own `CLAUDE.md` overriding the rule.

## Table of contents

- [Layout](#layout)
- [Editing files](#editing-files)
- [Adding a new stow package](#adding-a-new-stow-package)
- [Cross-platform guards](#cross-platform-guards)
- [Brewfile and bootstrap](#brewfile-and-bootstrap)
- [Plugin managers](#plugin-managers)
- [Verifying changes](#verifying-changes)
- [Docs site (mdBook)](#docs-site-mdbook)
- [Commits](#commits)
- [Per-subdir docs](#per-subdir-docs)

## Layout

Each top-level directory is a [GNU Stow](https://www.gnu.org/software/stow/)
package. Files inside it mirror the layout they should have under `$HOME`.
For example, `zsh/.zshrc` is symlinked to `~/.zshrc` by running
`stow zsh` from the repo root.

Current packages:

| Subdir              | Symlinks                                              |
| ------------------- | ----------------------------------------------------- |
| `atuin/`            | `~/.config/atuin/config.toml`                         |
| `bat/`              | `~/.config/bat/`                                      |
| `btop/`             | `~/.config/btop/`                                     |
| `direnv/`           | `~/.config/direnv/`                                   |
| `editorconfig/`     | `~/.editorconfig`                                     |
| `fzf/`              | `~/.fzf.zsh`                                          |
| `gh/`               | `~/.config/gh/config.yml` (hosts.yml stays untracked) |
| `git/`              | `~/.gitconfig`                                        |
| `gitignore_global/` | `~/.gitignore_global`                                 |
| `hadolint/`         | `~/.config/hadolint/`                                 |
| `kitty/`            | `~/.config/kitty/`                                    |
| `lazygit/`          | `~/.config/lazygit/`                                  |
| `lefthook/`         | (not stowed; template only)                           |
| `mise/`             | `~/.config/mise/config.toml`                          |
| `nvim/`             | `~/.config/nvim/`                                     |
| `p10k/`             | `~/.p10k.zsh`                                         |
| `ripgrep/`          | `~/.config/ripgrep/`                                  |
| `shellcheck/`       | `~/.shellcheckrc`                                     |
| `task/`             | `~/.config/task/`                                     |
| `tig/`              | `~/.tigrc`                                            |
| `tmux/`             | `~/.tmux.conf`                                        |
| `vim/`              | `~/.vimrc`, `~/.vim/`                                 |
| `yamllint/`         | `~/.config/yamllint/`                                 |
| `zsh/`              | `~/.zshrc`                                            |

Non-stow files at the root:

| File                  | Purpose                                               |
| --------------------- | ----------------------------------------------------- |
| `Brewfile`            | `brew bundle` input — tap/formula/cask/go-module pins |
| `bootstrap-debian.sh` | One-shot Debian/Ubuntu provisioning script            |
| `README.md`           | Human-facing entry point                              |
| `CLAUDE.md`           | This file                                             |

## Editing files

The user already has the dotfiles symlinked into `$HOME`. **Edit the files
in this repo, not the symlinks.** When you edit `zsh/.zshrc`, the change is
visible immediately at `~/.zshrc` because of the symlink — no copy step.

If you ever find a file in `$HOME` that should be a symlink but isn't
(regular file blocking the stow target), **stop and surface it to the
user** before deleting. That happened once with `~/.p10k.zsh` and
`~/.tmux.conf` — both turned out to be stale copies, but the right call
was to verify before overwriting.

## Adding a new stow package

When introducing a new tool's config:

1. Create `<tool>/` at the repo root.
2. Place files at the path they would have under `$HOME`. For
   `~/.foo/bar.conf`, put it at `<tool>/.foo/bar.conf`.
3. Add a `<tool>/README.md` documenting what makes it non-default.
4. Add `<tool>` to `STOW_PACKAGES` in `bootstrap-debian.sh` if it should be
   stowed by default on Linux.
5. If the tool ships via Homebrew, ensure it's in `Brewfile` (run
   `brew bundle dump --describe --force` to regenerate the whole file).

## Cross-platform guards

The user runs both macOS and Debian. Anything platform-specific must be
gated, never assumed:

- Binary presence: `command -v <tool> >/dev/null && …`
- Path existence: `[[ -d /opt/homebrew/… ]] && …`
- OS detection: `[[ "$OSTYPE" == darwin* ]]`
- Brew prefix: use `$(brew --prefix)` (works on Linuxbrew at `/home/linuxbrew/.linuxbrew`)

When adding a PATH entry, check the directory exists first — silent
broken paths are easy to introduce and hard to spot.

## Brewfile and bootstrap

- `Brewfile` is a **snapshot**, regenerated via `brew bundle dump --describe --force`. After installing new packages with `brew install`,
  regenerate so the snapshot stays current.
- `bootstrap-debian.sh` runs `brew bundle` and tolerates failures (some
  macOS-only casks like `claude-code` will error on Debian — `warn` and
  continue).
- Never add a tool to `Brewfile` by hand without installing it first —
  the file is meant to reflect what's actually installed.

## Plugin managers

| Tool | Plugin manager                        | Plugin dir                     |
| ---- | ------------------------------------- | ------------------------------ |
| zsh  | Oh My Zsh + git-cloned custom plugins | `~/.oh-my-zsh/custom/plugins/` |
| tmux | TPM (Tmux Plugin Manager)             | `~/.tmux/plugins/`             |
| vim  | vim-plug                              | `~/.vim/plugged/`              |

Headless plugin install commands for non-interactive use:

```sh
# vim-plug needs a real pty — run inside tmux:
command tmux new-session -d -s _install 'vim +"PlugInstall --sync" +qall'
while command tmux has-session -t _install 2>/dev/null; do sleep 2; done

# TPM also needs a live tmux server:
command tmux new-session -d -s _install 'sleep 30'
~/.tmux/plugins/tpm/bin/install_plugins
command tmux kill-session -t _install

# OMZ custom plugins are just git clones — no special incantation.
```

Note `command tmux` (not just `tmux`) — the OMZ `tmux` plugin wraps the
binary with `_zsh_tmux_plugin_run`, which doesn't exist in non-interactive
shells.

## Verifying changes

Before saying a change is complete, parse-check the affected file:

| File type                     | Check                                            |
| ----------------------------- | ------------------------------------------------ |
| `*.zsh`, `.zshrc`             | `zsh -n <file>`                                  |
| `*.sh`, `bootstrap-debian.sh` | `bash -n <file>` (and `shellcheck` if available) |
| `.vimrc`                      | open in vim, no startup errors                   |
| `.tmux.conf`                  | `tmux source-file <file>` in a live session      |

UI/visual changes (prompt, status bar, colors) need a real shell or pane to
verify — say so explicitly if you can't.

## Docs site (mdBook)

The per-subdir READMEs are also published as a browsable book at
<https://jacob-delgado.github.io/dotfiles/>, built by
`.github/workflows/docs.yml` on push to `main`.

- `book.toml` configures mdBook; `src/SUMMARY.md` lists the chapters.
- Each chapter file in `src/<pkg>.md` is a one-line wrapper that does
  `{{#include ../<pkg>/README.md}}` — single source of truth, no
  duplication. **Edit the package README, not the wrapper.**
- When adding a new stow package, also: (a) add a line to `src/SUMMARY.md`,
  and (b) create `src/<pkg>.md` with the include directive.
- Local preview: `mdbook serve --open` (or `mdbook build` for a one-shot
  render into `book/`, which is gitignored).
- The CI workflow runs on PRs (build-only, no deploy) and on push to
  `main` (build + deploy to GitHub Pages). Trigger a manual rebuild via
  the workflow's `workflow_dispatch`.

## Commits

- One commit per logical change. Don't batch unrelated edits.
- Commit message: short imperative subject, then body explaining the
  *why*. Always include the `Co-Authored-By: Claude Opus 4.7 …` trailer.
- Don't push without being asked.
- Don't run destructive git operations (`reset --hard`, force-push) unless
  explicitly told.

## Per-subdir docs

Each subdir has its own `README.md` documenting what makes that package
non-default. Read those before editing — they often capture rationale
that isn't obvious from the config alone.
