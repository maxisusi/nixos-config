{ pkgs }:

pkgs.writeShellScriptBin "webapp-launcher" ''
  #!/usr/bin/env bash

  # Check if URL is provided
  if [ $# -eq 0 ]; then
    echo "Usage: webapp-launcher <URL> [additional-args...]"
    exit 1
  fi

  URL="$1"
  shift  # Remove first argument, keep the rest as additional args

  # Check if Google Chrome is available
  if command -v google-chrome-stable >/dev/null 2>&1; then
    # Use Google Chrome in app mode (removes browser chrome, creates dedicated window)
    exec google-chrome-stable \
      --app="$URL" \
      --new-window \
      --class="WebApp-$(basename "$URL" | sed 's/[^a-zA-Z0-9]//g')" \
      --user-data-dir="$HOME/.local/share/webapps/$(basename "$URL" | sed 's/[^a-zA-Z0-9]//g')" \
      "$@"
  elif command -v google-chrome >/dev/null 2>&1; then
    # Fallback to google-chrome
    exec google-chrome \
      --app="$URL" \
      --new-window \
      --class="WebApp-$(basename "$URL" | sed 's/[^a-zA-Z0-9]//g')" \
      --user-data-dir="$HOME/.local/share/webapps/$(basename "$URL" | sed 's/[^a-zA-Z0-9]//g')" \
      "$@"
  elif command -v chromium >/dev/null 2>&1; then
    # Fallback to chromium
    exec chromium \
      --app="$URL" \
      --new-window \
      --class="WebApp-$(basename "$URL" | sed 's/[^a-zA-Z0-9]//g')" \
      --user-data-dir="$HOME/.local/share/webapps/$(basename "$URL" | sed 's/[^a-zA-Z0-9]//g')" \
      "$@"
  else
    echo "Error: No supported browser found. Please install Google Chrome or Chromium."
    exit 1
  fi
''
