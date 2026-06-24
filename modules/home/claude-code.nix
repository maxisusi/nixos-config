{ pkgs, lib, ... }:
let
  claude-hud-src = pkgs.fetchFromGitHub {
    owner = "jarrodwatts";
    repo = "claude-hud";
    rev = "v0.0.12";
    hash = "sha256-qrF1kz7EPt1g5F4y51nrDjmyoZlxt8hcfjoejCLCiQA=";
  };

  # ponytail: "lazy senior dev" Claude Code plugin (skills + hooks).
  # Installed the Nix way: fetch the marketplace repo into the store and point
  # Claude at it as a read-only "directory" marketplace via settings.json
  # (extraKnownMarketplaces + enabledPlugins). Claude copies it into its plugin
  # cache on next launch; no interactive `/plugin` commands needed.
  ponytail-src = pkgs.fetchFromGitHub {
    owner = "hyeongchankim";
    repo = "poneytail";
    rev = "dedc97ca7c8a1e7463ac5b36f7fe4b28c3c435a2"; # v4.7.0
    hash = "sha256-YUHjZfCTOIWrHJUUvnuoRSNG/l7wBuMQx/EdRdbLO3w=";
  };

  claude-hud-statusline = pkgs.writeShellScript "claude-hud-statusline" ''
    cols=$(stty size </dev/tty 2>/dev/null | awk '{print $2}')
    export COLUMNS=$(( ''${cols:-120} > 4 ? ''${cols:-120} - 4 : 1 ))
    exec ${pkgs.nodejs}/bin/node ${claude-hud-src}/dist/index.js
  '';

  hooks-log = "$HOME/.cache/claude-code/hooks.log";

  # Helper that logs payloads and extracts cwd basename
  # Stop hook: title shows project, body shows last user prompt snippet
  hook-stop = pkgs.writeShellScript "claude-hook-stop" ''
    mkdir -p "$(dirname "${hooks-log}")"
    payload=$(${pkgs.coreutils}/bin/cat)
    printf '%s [Stop] %s\n' "$(${pkgs.coreutils}/bin/date -Iseconds)" "$payload" >> "${hooks-log}"

    dir=$(printf '%s' "$payload" | ${pkgs.jq}/bin/jq -r '.cwd // ""')
    [ -z "$dir" ] && dir="$PWD"
    project=$(${pkgs.coreutils}/bin/basename "$dir")

    transcript=$(printf '%s' "$payload" | ${pkgs.jq}/bin/jq -r '.transcript_path // ""')
    ctx=""
    if [ -n "$transcript" ] && [ -f "$transcript" ]; then
      ctx=$(${pkgs.coreutils}/bin/tail -n 500 "$transcript" 2>/dev/null \
        | ${pkgs.jq}/bin/jq -r 'select(.type == "user") |
            if (.message.content | type) == "string" then .message.content
            elif (.message.content | type) == "array" then (.message.content[] | select(.type == "text") | .text)
            else empty end' 2>/dev/null \
        | ${pkgs.gnugrep}/bin/grep -v '^$' \
        | ${pkgs.coreutils}/bin/tail -n 1 \
        | ${pkgs.coreutils}/bin/head -c 60)
    fi

    body="$project"
    [ -n "$ctx" ] && body="$project · $ctx"

    ${pkgs.dunst}/bin/dunstify -a 'Claude Code' -u normal 'Claude finished' "$body" 2>/dev/null || true
  '';

  # Notification hook: fires for many things including end-of-turn bell.
  # Only show dunstify popup when the message indicates the user is actually needed.
  hook-notification = pkgs.writeShellScript "claude-hook-notification" ''
    mkdir -p "$(dirname "${hooks-log}")"
    payload=$(${pkgs.coreutils}/bin/cat)
    printf '%s [Notification] %s\n' "$(${pkgs.coreutils}/bin/date -Iseconds)" "$payload" >> "${hooks-log}"

    msg=$(printf '%s' "$payload" | ${pkgs.jq}/bin/jq -r '.message // ""')
    case "$msg" in
      *permission*|*Permission*|*waiting*|*Waiting*|*needs*|*Needs*) ;;
      *) exit 0 ;;
    esac

    dir=$(printf '%s' "$payload" | ${pkgs.jq}/bin/jq -r '.cwd // ""')
    [ -z "$dir" ] && dir="$PWD"
    project=$(${pkgs.coreutils}/bin/basename "$dir")

    ${pkgs.dunst}/bin/dunstify -a 'Claude Code' -u critical 'Claude needs you' "$project · $msg" 2>/dev/null || true
  '';

  # PermissionRequest hook: fires when a real permission prompt is about to show.
  hook-permission = pkgs.writeShellScript "claude-hook-permission" ''
    mkdir -p "$(dirname "${hooks-log}")"
    payload=$(${pkgs.coreutils}/bin/cat)
    printf '%s [PermissionRequest] %s\n' "$(${pkgs.coreutils}/bin/date -Iseconds)" "$payload" >> "${hooks-log}"

    dir=$(printf '%s' "$payload" | ${pkgs.jq}/bin/jq -r '.cwd // ""')
    [ -z "$dir" ] && dir="$PWD"
    project=$(${pkgs.coreutils}/bin/basename "$dir")

    action=$(printf '%s' "$payload" \
      | ${pkgs.jq}/bin/jq -r '[.tool_name, (.tool_input.command // .tool_input.file_path // .tool_input.url // .tool_input.pattern // "")] | join(": ")' \
      | ${pkgs.coreutils}/bin/head -c 120)

    ${pkgs.dunst}/bin/dunstify -a 'Claude Code' -u critical 'Claude needs you' "$project · $action" 2>/dev/null || true
  '';

  settingsFile = (pkgs.formats.json { }).generate "claude-settings.json" settings;

  claudeHudConfigFile = (pkgs.formats.json { }).generate "claude-hud-config.json" claudeHudConfig;

  claudeHudConfig = {
    display = {
      showCost = true;
    };
  };

  settings = {
    permissions = {
      defaultMode = "auto";
    };
    model = "opus[1m]";
    effortLevel = "xhigh";
    skipDangerousModePermissionPrompt = true;
    skipAutoPermissionPrompt = true;
    voiceEnabled = true;
    voice = {
      enabled = true;
      mode = "hold";
    };
    statusLine = {
      type = "command";
      command = "${claude-hud-statusline}";
    };
    extraKnownMarketplaces = {
      ponytail.source = {
        source = "directory";
        path = "${ponytail-src}";
      };
    };
    enabledPlugins = {
      "ponytail@ponytail" = true;
    };
    hooks = {
      Stop = [{ hooks = [{ type = "command"; command = "${hook-stop}"; }]; }];
      Notification = [{ hooks = [{ type = "command"; command = "${hook-notification}"; }]; }];
      PermissionRequest = [{ hooks = [{ type = "command"; command = "${hook-permission}"; }]; }];
    };
  };
in
{
  # Install settings.json as a mutable file so runtime commands like /voice
  # can write to it. A symlinked source from home.file would point into the
  # read-only Nix store and any in-app settings write would fail.
  home.activation.claudeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    target="$HOME/.claude/settings.json"
    $DRY_RUN_CMD rm -f "$target"
    $DRY_RUN_CMD install -D -m 0644 ${settingsFile} "$target"
  '';

  # claude-hud reads its config from this path. Install as mutable so
  # /claude-hud:configure can still write to it at runtime.
  home.activation.claudeHudConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    target="$HOME/.claude/plugins/claude-hud/config.json"
    $DRY_RUN_CMD rm -f "$target"
    $DRY_RUN_CMD install -D -m 0644 ${claudeHudConfigFile} "$target"
  '';
}
