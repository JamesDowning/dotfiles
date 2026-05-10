#!/bin/zsh
set -euo pipefail

# Always run from the dotfiles repo root.
cd "$(dirname "$0")"

HOMEBREW_INSTALL_URL="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"

FORMULAE=(
  bat
  direnv
  fd
  fzf
  go
  helm
  k9s
  kind
  kubectl
  kustomize
  neovim
  ripgrep
  starship
  stow
  tfenv
)

CASKS_AND_APPS=(
  "1password|1Password.app"
  "docker|Docker.app"
  "kitty|kitty.app"
  "visual-studio-code|Visual Studio Code.app"
)

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

load_homebrew_shellenv() {
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

ensure_homebrew() {
  load_homebrew_shellenv

  if command_exists brew; then
    echo "Homebrew already installed"
    return
  fi

  echo "Installing Homebrew"
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL "$HOMEBREW_INSTALL_URL")"

  load_homebrew_shellenv

  if ! command_exists brew; then
    echo "Homebrew installed but brew is not available on PATH" >&2
    exit 1
  fi
}

install_formula() {
  local formula="$1"

  if brew list --formula "$formula" >/dev/null 2>&1; then
    echo "Formula already installed: $formula"
    return
  fi

  echo "Installing formula: $formula"
  brew install "$formula"
}

install_cask() {
  local cask="${1%%|*}"
  local app_name="${1#*|}"

  if brew list --cask "$cask" >/dev/null 2>&1; then
    echo "Cask already installed: $cask"
    return
  fi

  if [ -d "/Applications/$app_name" ] || [ -d "$HOME/Applications/$app_name" ]; then
    echo "Application already installed: $app_name"
    return
  fi

  echo "Installing cask: $cask"
  brew install --cask "$cask"
}

install_tools() {
  local formula
  local cask

  echo "Installing command line tools"
  for formula in "${FORMULAE[@]}"; do
    install_formula "$formula"
  done

  echo "Installing applications"
  for cask in "${CASKS_AND_APPS[@]}"; do
    install_cask "$cask"
  done
}

stow_dotfiles() {
  local dir
  local pkg

  echo "Stowing dotfiles"
  for dir in */; do
    pkg="${dir%/}"
    echo "Stowing package: $pkg"
    stow -t "$HOME" "$pkg"
  done
}

main() {
  ensure_homebrew
  install_tools
  stow_dotfiles

  echo "Dotfiles setup complete"
}

main "$@"
