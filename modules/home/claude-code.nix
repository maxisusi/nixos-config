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

  home.file.".claude/CLAUDE.md".source = ./claude-guidelines.md;

  # claude-hud reads its config from this path. Install as mutable so
  # /claude-hud:configure can still write to it at runtime.
  home.activation.claudeHudConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    target="$HOME/.claude/plugins/claude-hud/config.json"
    $DRY_RUN_CMD rm -f "$target"
    $DRY_RUN_CMD install -D -m 0644 ${claudeHudConfigFile} "$target"
  '';
}
