#!/bin/zsh
set -e

# Always run from the dotfiles repo root
cd "$(dirname "$0")"

# Stow each top-level directory into $HOME
for dir in */; do
  [ "$dir" = ".git/" ] && continue

  pkg="${dir%/}"
  echo "Stowing package: $pkg"
  stow -t ~ "$pkg"
done

echo "Dotfiles setup complete"