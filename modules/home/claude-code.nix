{ pkgs, ... }:
let
  claude-hud-src = pkgs.fetchFromGitHub {
    owner = "jarrodwatts";
    repo = "claude-hud";
    rev = "v0.0.12";
    hash = "sha256-qrF1kz7EPt1g5F4y51nrDjmyoZlxt8hcfjoejCLCiQA=";
  };

  claude-hud-statusline = pkgs.writeShellScript "claude-hud-statusline" ''
    cols=$(stty size </dev/tty 2>/dev/null | awk '{print $2}')
    export COLUMNS=$(( ''${cols:-120} > 4 ? ''${cols:-120} - 4 : 1 ))
    exec ${pkgs.nodejs}/bin/node ${claude-hud-src}/dist/index.js
  '';

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
    hooks = {
      Stop = [
        {
          hooks = [
            {
              type = "command";
              command = ''dunstify -a 'Claude Code' -u normal 'Claude finished' "$(basename "$(pwd)")" 2>/dev/null || true'';
            }
          ];
        }
      ];
      PermissionRequest = [
        {
          hooks = [
            {
              type = "command";
              command = ''msg=$(jq -r '[.tool_name, (.tool_input.command // .tool_input.file_path // .tool_input.url // .tool_input.pattern // "")] | join(": ")' | head -c 200); dunstify -a 'Claude Code' -u critical 'Claude needs you' "$msg" 2>/dev/null || true'';
            }
          ];
        }
      ];
    };
  };
in
{
  home.file.".claude/settings.json" = {
    source = (pkgs.formats.json { }).generate "claude-settings.json" settings;
    force = true;
  };
}
