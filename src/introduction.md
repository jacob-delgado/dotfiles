# dotfiles

Personal dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).
Each chapter in the sidebar covers one stow package — what the tool is, what's
been changed from the defaults, and the everyday commands worth knowing.

## How this book is built

The book is generated from the per-package READMEs in the repo. Every chapter
is a thin wrapper that pulls in the matching `README.md` via mdBook's
`{{#include}}` directive — so the GitHub repo and this site never drift.

If you want install instructions (Debian / macOS), the modern-CLI tour
(zoxide, eza, dust, hyperfine, etc.), or the full subdirectory table, those
live in the [repo README on GitHub][repo-readme].

[repo-readme]: https://github.com/jacob-delgado/dotfiles#readme

## Conventions

- Every top-level directory in the repo is a stow package mirroring the
  layout it should have under `$HOME`. For example, `zsh/.zshrc` is
  symlinked to `~/.zshrc` by running `stow zsh` from the repo root.
- The same `bootstrap-debian.sh` script handles a fresh Debian/Ubuntu box;
  `brew bundle` covers macOS.
- Repo-wide conventions for editing live in
  [`CLAUDE.md`](https://github.com/jacob-delgado/dotfiles/blob/main/CLAUDE.md).

## Quick install

```sh
git clone https://github.com/jacob-delgado/dotfiles ~/dotfiles
cd ~/dotfiles
# Debian / Ubuntu
./bootstrap-debian.sh
# macOS
brew bundle && stow zsh vim tmux fzf   # pick whichever packages you want
```
