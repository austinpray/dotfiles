#!/bin/bash
set -euo pipefail

CONFIG_FILE="$HOME/.config/discord/settings.json"

# Create config directory if it doesn't exist
mkdir -p "$(dirname "$CONFIG_FILE")"

# Check if file exists and already has the correct setting
if [ -f "$CONFIG_FILE" ]; then
  CURRENT_VALUE=$(jq -r '.SKIP_HOST_UPDATE // "not_set"' "$CONFIG_FILE")

  if [ "$CURRENT_VALUE" = "true" ]; then
    echo "Discord: SKIP_HOST_UPDATE already set to true"
    exit 0
  fi

  echo "Discord: Updating SKIP_HOST_UPDATE to true"
  # Update existing file with jq
  jq '. + {"SKIP_HOST_UPDATE": true}' "$CONFIG_FILE" > "$CONFIG_FILE.tmp"
  mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
else
  echo "Discord: Creating settings.json with SKIP_HOST_UPDATE=true"
  # Create new file
  echo '{"SKIP_HOST_UPDATE": true}' | jq '.' > "$CONFIG_FILE"
fi

echo "Discord: Configuration complete"
