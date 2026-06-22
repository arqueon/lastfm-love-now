#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${LASTFM_LOVE_INSTALL_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/niri/scripts}"
TARGET_SCRIPT="$TARGET_DIR/lastfm-love-now"
TARGET_ENV="$TARGET_DIR/lastfm-love.env"

mkdir -p "$TARGET_DIR"
install -m 700 "$SCRIPT_DIR/lastfm-love-now" "$TARGET_SCRIPT"

if [[ ! -e "$TARGET_ENV" ]]; then
  install -m 600 "$SCRIPT_DIR/lastfm-love.env.example" "$TARGET_ENV"
  printf 'Created config template: %s\n' "$TARGET_ENV"
else
  chmod 600 "$TARGET_ENV"
  printf 'Kept existing config: %s\n' "$TARGET_ENV"
fi

printf 'Installed: %s\n' "$TARGET_SCRIPT"
printf 'Run setup with:\n  %s setup\n' "$TARGET_SCRIPT"
