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

# Install espanso itself if missing
if ! command -v espanso >/dev/null 2>&1; then
  echo "Espanso not installed — installing..."
  if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install espanso
  elif command -v yay >/dev/null 2>&1; then
    # Arch: pick the build matching the display server
    if [ "$XDG_SESSION_TYPE" = "wayland" ] || [ -n "$WAYLAND_DISPLAY" ]; then
      yay -S --needed espanso-wayland-bin
    else
      yay -S --needed espanso-x11-bin
    fi
  else
    echo "No supported installer found (brew/yay)."
    echo "Install espanso manually: https://espanso.org/install/"
    exit 1
  fi
fi

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

# Register and start the service
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  if [ ! -f "$HOME/.config/systemd/user/espanso.service" ]; then
    espanso service register
  fi
  # The Debian-built AUR binary's "espanso launcher" segfaults on Arch
  # (wxwidgets mismatch), so run the daemon directly instead.
  mkdir -p "$HOME/.config/systemd/user/espanso.service.d"
  printf '[Service]\nExecStart=\nExecStart=%s daemon\n' "$(command -v espanso)" \
    > "$HOME/.config/systemd/user/espanso.service.d/override.conf"
  systemctl --user daemon-reload
  systemctl --user restart espanso.service
else
  espanso service register 2>/dev/null || true
  espanso restart || espanso start
fi

echo ""
echo "✅ Done! Espanso is running with config from: $REPO_DIR"
