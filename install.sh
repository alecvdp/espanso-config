#!/usr/bin/env bash
# Espanso config installer
# Usage: ./install.sh
# Detects OS, backs up existing config, symlinks or copies this repo into place

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Detect espanso config directory
if [[ "$OSTYPE" == "darwin"* ]]; then
  ESPANSO_DIR="$HOME/Library/Application Support/espanso"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  ESPANSO_DIR="$HOME/.config/espanso"
else
  echo "Unsupported OS: $OSTYPE"
  exit 1
fi

echo "Espanso config dir: $ESPANSO_DIR"

# Backup existing config if it exists and isn't already this repo
if [ -d "$ESPANSO_DIR" ] && [ ! -L "$ESPANSO_DIR/match" ]; then
  BACKUP="$ESPANSO_DIR.backup.$(date +%Y%m%d%H%M%S)"
  echo "Backing up existing config to $BACKUP"
  cp -r "$ESPANSO_DIR" "$BACKUP"
fi

# Ensure config dir exists
mkdir -p "$ESPANSO_DIR"

# Symlink match and config directories
for dir in match config; do
  TARGET="$ESPANSO_DIR/$dir"
  SOURCE="$REPO_DIR/$dir"

  if [ -L "$TARGET" ]; then
    echo "Updating symlink: $TARGET → $SOURCE"
    ln -sf "$SOURCE" "$TARGET"
  elif [ -d "$TARGET" ]; then
    echo "Removing old $dir dir and symlinking..."
    rm -rf "$TARGET"
    ln -s "$SOURCE" "$TARGET"
  else
    echo "Symlinking: $TARGET → $SOURCE"
    ln -s "$SOURCE" "$TARGET"
  fi
done

echo ""
echo "✅ Done! Espanso is now using config from: $REPO_DIR"
echo "   Restart Espanso if it's running: espanso restart"
