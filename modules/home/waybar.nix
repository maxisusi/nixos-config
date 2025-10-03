{ config, pkgs, inputs, ... }:
let
  themeCSS = with config.lib.stylix.colors; ''
    * {
      color: #${base05};
    }
    window#waybar {
      background-color: #${base00};
    }
  '';
  styleCSS = ''
    * {
      border: none;
      border-radius: 0;
      min-height: 0;
      font-size: 16px;
    }

    #workspaces {
      margin-left: 7px;
    }

    #workspaces button {
      all: initial;
      padding: 2px 6px;
      margin-right: 3px;
    }

    #custom-dropbox,
    #cpu,
    #power-profiles-daemon,
    #battery,
    #network,
    #bluetooth,
    #wireplumber,
    #tray,
    #clock {
      background-color: transparent;
      min-width: 12px;
      margin-right: 13px;
    }

    tooltip {
      padding: 2px;
    }

    tooltip label {
      padding: 2px;
    }
  '';
in {
  programs.waybar = {
    enable = true;
    style = themeCSS + "\n" + styleCSS;
    settings = [{
      layer = "top";
      position = "top";
      spacing = 0;
      height = 26;
      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "clock" ];
      modules-right = [
        # "custom/dropbox"
        "tray"
        "bluetooth"
        "network"
        "wireplumber"
        "cpu"
        "power-profiles-daemon"
        "battery"
      ];
      "hyprland/workspaces" = {
        on-click = "activate";
        format = "{icon}";
        format-icons = {
          default = "";
          "1" = "1";
          "2" = "2";
          "3" = "3";
          "4" = "4";
          "5" = "5";
          "6" = "6";
          "7" = "7";
          "8" = "8";
          "9" = "9";
          active = "󱓻";
        };
        persistent-workspaces = {
          "1" = [ ];
          "2" = [ ];
          "3" = [ ];
          "4" = [ ];
          "5" = [ ];
        };
      };
      cpu = {
        interval = 5;
        format = "󰍛";
        on-click = "kitty btop";
      };
      clock = {
        format = "{:%A %I:%M %p}";
        format-alt = "{:%d %B W%V %Y}";
        tooltip = false;
      };
      network = {
        format-icons = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
        format = "{icon}";
        format-wifi = "{icon}";
        format-ethernet = "󰀂";
        format-disconnected = "󰖪";
        tooltip-format-wifi = ''
          {essid} ({frequency} GHz)
          ⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}'';
        tooltip-format-ethernet = "⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
        tooltip-format-disconnected = "Disconnected";
        interval = 3;
        nospacing = 1;
        on-click = "kitty nmcli";
      };
      battery = {
        interval = 5;
        format = "{capacity}% {icon}";
        format-discharging = "{icon}";
        format-charging = "{icon}";
        format-plugged = "";
        format-icons = {
          charging = [ "󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅" ];
          default = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        };
        format-full = "Charged ";
        tooltip-format-discharging = "{power:>1.0f}W↓ {capacity}%";
        tooltip-format-charging = "{power:>1.0f}W↑ {capacity}%";
        states = {
          warning = 20;
          critical = 10;
        };
      };
      bluetooth = {
        format = "󰂯";
        format-disabled = "󰂲";
        format-connected = "";
        tooltip-format = "Devices connected: {num_connections}";
        on-click = "kitty bluetui";
      };
      wireplumber = {
        # Changed from "pulseaudio"
        "format" = "";
        format-muted = "󰝟";
        scroll-step = 5;
        tooltip-format = "Playing at {volume}%";
        on-click = "kitty wiremix --tab output"; # Updated command
        max-volume = 150; # Optional: allow volume over 100%
      };
      tray = { spacing = 13; };
      power-profiles-daemon = {
        format = "{icon}";
        tooltip-format = "Power profile: {profile}";
        tooltip = true;
        format-icons = {
          power-saver = "󰡳";
          balanced = "󰊚";
          performance = "󰡴";
        };
      };
      # "custom/dropbox" = {
      #   format = "";
      #   on-click = "nautilus ~/Dropbox";
      #   exec = "dropbox-cli status";
      #   return-type = "text";
      #   interval = 5;
      #   tooltip = true;
      #   tooltip-format = "{}";
      # };
    }];
  };
}
