#!/usr/bin/env bash
# Bootstrap a Debian/Ubuntu machine to match the dotfiles setup.
# Idempotent — safe to re-run.
#
# Usage:
#   ./bootstrap-debian.sh
#
# Runs from wherever the repo is checked out (the location is derived from this
# script's path), so it works whether the clone lives at ~/dotfiles or, as in
# the headless `devbox` flow, ~/.dotfiles. Override with
# DOTFILES_DIR=/path/to/repo ./bootstrap-debian.sh.
#
# Fully non-interactive: designed to run over SSH with no TTY as a
# passwordless-sudo user. No prompts, no Homebrew — tools come from apt and
# mise (https://mise.jdx.dev).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-${SCRIPT_DIR}}"
STOW_PACKAGES=(atuin bat btop direnv editorconfig fzf gh git gitignore_global hadolint kitty lazygit mise nvim p10k ripgrep shellcheck task tig tmux vim yamllint zsh)
# lefthook is a per-project template (lefthook/lefthook.yml), not stowed into $HOME.
ZSH_CUSTOM="${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}"

log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!! \033[0m %s\n' "$*" >&2; }
err() {
  printf '\033[1;31mXX \033[0m %s\n' "$*" >&2
  exit 1
}

[[ -d "${DOTFILES_DIR}" ]] || err "Dotfiles repo not found at ${DOTFILES_DIR} (clone it or set DOTFILES_DIR)."
[[ -f /etc/debian_version ]] || err "This script is for Debian/Ubuntu; /etc/debian_version not found."

# ---------------------------------------------------------------------------
# 1. apt prerequisites
# ---------------------------------------------------------------------------
# Base system + the CLIs Debian packages well. fzf and direnv MUST come from
# apt (not mise): their oh-my-zsh plugins load during `source oh-my-zsh.sh`,
# before `mise activate` runs, so they have to be on PATH from the start. The
# modern-CLI replacements (bat, eza, ripgrep, …) come from mise instead — see
# mise/.config/mise/config.toml.
log "Installing apt prerequisites"
sudo apt-get update
sudo apt-get install -y \
  build-essential \
  ca-certificates \
  curl \
  direnv \
  file \
  fzf \
  git \
  jq \
  procps \
  stow \
  tig \
  tmux \
  unzip \
  vim \
  zsh \
  zsh-syntax-highlighting

# ---------------------------------------------------------------------------
# 2. mise (the primary tool manager on Linux — replaces Homebrew here)
# ---------------------------------------------------------------------------
# Installed from mise's own apt repo (deb822 source + armored key, the same
# pattern the devbox Ansible role uses). Skipped when mise is already present,
# e.g. devbox installs it before this script runs.
if ! command -v mise >/dev/null 2>&1; then
  log "Installing mise from its apt repository"
  arch="$(dpkg --print-architecture)"
  sudo install -d -m 0755 /etc/apt/keyrings
  sudo curl -fsSL https://mise.jdx.dev/gpg-key.pub -o /etc/apt/keyrings/mise.asc
  sudo chmod 0644 /etc/apt/keyrings/mise.asc
  printf 'Types: deb\nURIs: https://mise.jdx.dev/deb\nSuites: stable\nComponents: main\nArchitectures: %s\nSigned-By: /etc/apt/keyrings/mise.asc\n' \
    "${arch}" | sudo tee /etc/apt/sources.list.d/mise.sources >/dev/null
  sudo apt-get update
  sudo apt-get install -y mise
fi
command -v mise >/dev/null 2>&1 || warn "mise is not on PATH; the tool-install step below will be skipped."

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
  # away anyone's real files.
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
# 7. mise-managed tools (runtimes + modern CLIs)
# ---------------------------------------------------------------------------
# The mise package (stowed above) placed ~/.config/mise/config.toml, so this
# materializes everything declared there. MISE_YES answers any confirmation;
# run from $HOME so no repo-local config sneaks in. Non-fatal — a flaky backend
# shouldn't abort the whole bootstrap. (devbox also runs `mise install` after
# this script; the second run is a fast no-op.)
if command -v mise >/dev/null 2>&1; then
  log "Installing mise-managed tools (this can take a while)"
  (cd "${HOME}" && MISE_YES=1 mise install) || warn "mise install reported errors; check 'mise doctor'."
fi

# ---------------------------------------------------------------------------
# 8. Default shell
# ---------------------------------------------------------------------------
# `sudo chsh` edits /etc/passwd as root, so it never triggers chsh's own PAM
# password prompt — the plain `chsh` would hang over a no-TTY SSH session.
zsh_path="$(command -v zsh)"
target_user="$(id -un)"
current_shell="$(getent passwd "${target_user}" | cut -d: -f7)"
if [[ "${current_shell}" != "${zsh_path}" ]]; then
  log "Setting default shell to ${zsh_path} for ${target_user}"
  sudo chsh -s "${zsh_path}" "${target_user}"
fi

log "Done."
echo
echo "Next steps (run from a fresh zsh):"
echo "  atuin import auto         # backfill existing shell history into atuin"
