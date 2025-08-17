#!/bin/bash
# create-symlinks.sh
# Create symlinks in XDG_CONFIG_HOME (or ~/.config) for all subdirectories
# inside the directory where this script resides.

set -euo pipefail

# Resolve paths
SOURCE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
TARGET_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

mkdir -p "$TARGET_DIR"

had_error=0

# Only iterate over subdirectories of the script's directory
shopt -s nullglob
for dir in "$SOURCE_DIR"/*/; do
  name="${dir%/}"
  name="${name##*/}"

  src="$dir"
  dest="$TARGET_DIR/$name"

  # If dest is a symlink
  if [ -L "$dest" ]; then
    if [ "$dest" -ef "$src" ]; then
      echo "OK: $dest already links to $src — skipping."
      continue
    else
      # Symlink exists but points elsewhere
      echo "ERROR: $dest is a symlink to '$(readlink "$dest")', not '$src' — leaving untouched." >&2
      had_error=1
      continue
    fi
  fi

  # If dest exists (file or directory) but isn't a symlink
  if [ -e "$dest" ]; then
    echo "ERROR: $dest already exists and is not a symlink — leaving untouched." >&2
    had_error=1
    continue
  fi

  # Create the symlink
  echo "Linking $src -> $dest"
  ln -s "$src" "$dest"
done

exit "$had_error"

