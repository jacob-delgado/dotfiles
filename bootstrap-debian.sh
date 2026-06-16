#!/usr/bin/env bash
# Bootstrap a Debian/Ubuntu machine to match the dotfiles setup.
# Idempotent — safe to re-run.
#
# Usage:
#   ./bootstrap-debian.sh
#
# Assumes the dotfiles repo is checked out at $HOME/dotfiles (override with
# DOTFILES_DIR=/path/to/repo ./bootstrap-debian.sh).

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
STOW_PACKAGES=(atuin bat btop direnv editorconfig fzf gh git gitignore_global hadolint kitty lazygit nvim p10k ripgrep shellcheck task tig tmux vim yamllint zsh)
# lefthook is a per-project template (lefthook/lefthook.yml), not stowed into $HOME.
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!! \033[0m %s\n' "$*" >&2; }
err()  { printf '\033[1;31mXX \033[0m %s\n' "$*" >&2; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }

[[ -d "$DOTFILES_DIR" ]] || err "Dotfiles repo not found at $DOTFILES_DIR (clone it or set DOTFILES_DIR)."
[[ -f /etc/debian_version ]] || err "This script is for Debian/Ubuntu; /etc/debian_version not found."

# ---------------------------------------------------------------------------
# 1. apt prerequisites
# ---------------------------------------------------------------------------
log "Installing apt prerequisites"
sudo apt-get update
sudo apt-get install -y \
  build-essential \
  curl \
  file \
  git \
  procps \
  stow \
  zsh \
  zsh-syntax-highlighting

# ---------------------------------------------------------------------------
# 2. Homebrew (Linuxbrew)
# ---------------------------------------------------------------------------
if ! have brew; then
  log "Installing Homebrew"
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Make brew available in this script's PATH for the steps that follow.
if [[ -d /home/linuxbrew/.linuxbrew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ -d "$HOME/.linuxbrew" ]]; then
  eval "$("$HOME"/.linuxbrew/bin/brew shellenv)"
fi
have brew || err "brew install succeeded but the binary isn't on PATH; check Homebrew docs."

# ---------------------------------------------------------------------------
# 3. Brew bundle (formulae + casks + go modules)
# ---------------------------------------------------------------------------
log "Running brew bundle from $DOTFILES_DIR/Brewfile (this can take a while)"
brew bundle --file="$DOTFILES_DIR/Brewfile" || warn "Some Brewfile entries failed (likely macOS-only casks); continuing."

# ---------------------------------------------------------------------------
# 4. Oh My Zsh
# ---------------------------------------------------------------------------
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  log "Installing oh-my-zsh"
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# ---------------------------------------------------------------------------
# 5. powerlevel10k theme
# ---------------------------------------------------------------------------
P10K_DIR="$ZSH_CUSTOM/themes/powerlevel10k"
if [[ ! -d "$P10K_DIR" ]]; then
  log "Installing powerlevel10k theme"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k "$P10K_DIR"
fi

# ---------------------------------------------------------------------------
# 6. OMZ custom plugins (the ones .zshrc conditionally loads)
# ---------------------------------------------------------------------------
install_plugin() {
  local name=$1 url=$2 dest="$ZSH_CUSTOM/plugins/$1"
  if [[ ! -d "$dest" ]]; then
    log "Installing OMZ plugin: $name"
    git clone --depth=1 "$url" "$dest"
  fi
}
install_plugin zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions
install_plugin fzf-tab             https://github.com/Aloxaf/fzf-tab
install_plugin you-should-use      https://github.com/MichaelAquilina/zsh-you-should-use

# ---------------------------------------------------------------------------
# 7. Stow the dotfile packages
# ---------------------------------------------------------------------------
log "Stowing dotfiles from $DOTFILES_DIR"
cd "$DOTFILES_DIR"
for pkg in "${STOW_PACKAGES[@]}"; do
  [[ -d "$pkg" ]] || { warn "Skipping $pkg (directory not in repo)"; continue; }
  # Detect non-symlink collisions in $HOME and bail loudly so we don't blow
  # away anyone's real files.
  while IFS= read -r -d '' f; do
    rel="${f#"$pkg"/}"
    target="$HOME/$rel"
    if [[ -e "$target" && ! -L "$target" ]]; then
      err "Refusing to stow $pkg: $target exists as a regular file. Move or delete it first."
    fi
  done < <(find "$pkg" -mindepth 1 -type f -print0)
  log "  stow -R $pkg"
  stow -R "$pkg"
done

# ---------------------------------------------------------------------------
# 8. Default shell
# ---------------------------------------------------------------------------
zsh_path="$(command -v zsh)"
if [[ "${SHELL:-}" != "$zsh_path" ]]; then
  log "Changing default shell to $zsh_path (you may be prompted for your password)"
  chsh -s "$zsh_path"
fi

log "Done."
echo
echo "Next steps (run from a fresh zsh):"
echo "  atuin import auto         # backfill existing shell history into atuin"
echo "  tldr --update             # populate the tealdeer cheat-sheet cache"
echo "  stow i3 Xresources        # only if you run i3 on this machine"
