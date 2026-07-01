#!/usr/bin/env bash
# Bootstrap a macOS machine to match the dotfiles setup.
# Idempotent — safe to re-run.
#
# Usage:
#   ./bootstrap-macos.sh
#
# The macOS counterpart to bootstrap-debian.sh. Here Homebrew stays the source
# of truth: `brew bundle` installs everything in the Brewfile. Non-interactive
# where it can be — installing Homebrew itself (only on a bare machine) may
# still prompt for the Xcode Command Line Tools / an admin password.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-${SCRIPT_DIR}}"
# mise is intentionally omitted: on macOS the tools come from Homebrew, so the
# global mise tool-list (mise/.config/mise/config.toml) is a Linux-only concern.
# Per-project mise.toml pinning inside individual repos still works — those are
# separate files, unaffected by not stowing the global one.
STOW_PACKAGES=(atuin bat btop direnv editorconfig fzf gh git gitignore_global hadolint kitty lazygit nvim p10k ripgrep shellcheck task tig tmux vim yamllint zsh)
ZSH_CUSTOM="${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}"

log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!! \033[0m %s\n' "$*" >&2; }
err() {
  printf '\033[1;31mXX \033[0m %s\n' "$*" >&2
  exit 1
}

[[ -d "${DOTFILES_DIR}" ]] || err "Dotfiles repo not found at ${DOTFILES_DIR} (clone it or set DOTFILES_DIR)."
[[ "${OSTYPE}" == darwin* ]] || err "This script is for macOS; \$OSTYPE is '${OSTYPE}'. Use bootstrap-debian.sh on Linux."

# ---------------------------------------------------------------------------
# 1. Homebrew
# ---------------------------------------------------------------------------
if ! command -v brew >/dev/null 2>&1; then
  log "Installing Homebrew"
  brew_installer="$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  NONINTERACTIVE=1 /bin/bash -c "${brew_installer}"
fi
# Put brew on PATH for the rest of this script (Apple Silicon vs Intel prefix).
for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  if [[ -x "${brew_bin}" ]]; then
    brew_env="$("${brew_bin}" shellenv)"
    eval "${brew_env}"
    break
  fi
done
command -v brew >/dev/null 2>&1 || err "brew install succeeded but the binary isn't on PATH; check Homebrew docs."

# ---------------------------------------------------------------------------
# 2. Brew bundle (formulae + casks + go modules)
# ---------------------------------------------------------------------------
log "Running brew bundle from ${DOTFILES_DIR}/Brewfile (this can take a while)"
brew bundle --file="${DOTFILES_DIR}/Brewfile"

# ---------------------------------------------------------------------------
# 3. Oh My Zsh
# ---------------------------------------------------------------------------
if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
  log "Installing oh-my-zsh"
  omz_installer="$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "${omz_installer}"
fi

# ---------------------------------------------------------------------------
# 4. powerlevel10k theme
# ---------------------------------------------------------------------------
P10K_DIR="${ZSH_CUSTOM}/themes/powerlevel10k"
if [[ ! -d "${P10K_DIR}" ]]; then
  log "Installing powerlevel10k theme"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k "${P10K_DIR}"
fi

# ---------------------------------------------------------------------------
# 5. OMZ custom plugins (the ones .zshrc conditionally loads)
# ---------------------------------------------------------------------------
install_plugin() {
  local name="$1" url="$2" dest="${ZSH_CUSTOM}/plugins/$1"
  if [[ ! -d "${dest}" ]]; then
    log "Installing OMZ plugin: ${name}"
    git clone --depth=1 "${url}" "${dest}"
  fi
}
install_plugin zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions
install_plugin fzf-tab https://github.com/Aloxaf/fzf-tab
install_plugin you-should-use https://github.com/MichaelAquilina/zsh-you-should-use

# ---------------------------------------------------------------------------
# 6. Stow the dotfile packages
# ---------------------------------------------------------------------------
log "Stowing dotfiles from ${DOTFILES_DIR}"
cd "${DOTFILES_DIR}"
for pkg in "${STOW_PACKAGES[@]}"; do
  [[ -d "${pkg}" ]] || {
    warn "Skipping ${pkg} (directory not in repo)"
    continue
  }
  # Detect non-symlink collisions in $HOME and bail loudly so we don't blow
  # away anyone's real files (this has bitten ~/.p10k.zsh and ~/.tmux.conf).
  # shellcheck disable=SC2312  # find can't meaningfully fail on an in-repo dir
  while IFS= read -r -d '' f; do
    rel="${f#"${pkg}"/}"
    target="${HOME}/${rel}"
    if [[ -e "${target}" && ! -L "${target}" ]]; then
      err "Refusing to stow ${pkg}: ${target} exists as a regular file. Move or delete it first."
    fi
  done < <(find "${pkg}" -mindepth 1 -type f -print0)
  log "  stow -R ${pkg}"
  stow -R "${pkg}"
done

# ---------------------------------------------------------------------------
# 7. Default shell
# ---------------------------------------------------------------------------
# Modern macOS already defaults to zsh, so this is usually a no-op. If it isn't,
# chsh may prompt for your password (PAM) — unavoidable without sudo.
if [[ "${SHELL:-}" != *zsh ]]; then
  zsh_path="$(command -v zsh)"
  log "Setting default shell to ${zsh_path}"
  chsh -s "${zsh_path}"
fi

log "Done."
echo
echo "Next steps (run from a fresh zsh):"
echo "  atuin import auto         # backfill existing shell history into atuin"
echo "  tldr --update             # populate the tealdeer cheat-sheet cache"
echo "  vim +\"PlugInstall --sync\" +qall   # install vim plugins"
