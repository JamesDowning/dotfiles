#!/bin/zsh
set -e

# Always run from the dotfiles repo root
cd "$(dirname "$0")"

# Stow each top-level directory into $HOME
for dir in */; do
  [ "$dir" = ".git/" ] && continue
  echo "Stowing package: $dir"
  stow -t ~ "${dir%/}"
done

echo "Dotfiles setup complete"