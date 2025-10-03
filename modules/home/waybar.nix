{ config, ... }: {
  programs.waybar = {
    enable = true;
    systemd = {
      enable = false;
      target = "graphical-session.target";
    };
    settings = [{
      "layer" = "top";
      "position" = "top";
      modules-left = [
        # "custom/launcher" 
        # "temperature"
        "hyprland/workspaces"
        "mpd"
        "custom/cava-internal"
      ];
      modules-center = [ "clock" ];
      modules-right = [
        "pulseaudio"
        # "backlight"
        "memory"
        "cpu"
        "battery"
        "network"
        # "custom/powermenu"
        "tray"
      ];
      # "custom/launcher" = {
      #   "format" = " ";
      #   "on-click" = "pkill rofi || rofi";
      #   "on-click-middle" = "exec default_wall";
      #   "on-click-right" = "exec wallpaper_random";
      #   "tooltip" = false;
      # };
      # "custom/cava-internal" = {
      #   "exec" = "sleep 1s && cava-internal";
      #   "tooltip" = false;
      # };
      "pulseaudio" = {
        "scroll-step" = 1;
        "format" = "{icon}";
        "format-muted" = "";
        "format-source" = "";
        "format-source-muted" = "";
        "format-icons" = { "default" = [ "" "" "" ]; };
        "on-click" = "pamixer -t";
        "tooltip" = false;
      };
      "battery" = {
        "interval" = 60;
        "format" = "{icon}";
        "format-icons" = [ "" "" "" "" ];
        "tooltip" = true;
        "tooltip-format" = "{capacity}%";
      };
      "clock" = {
        "interval" = 1;
        "format" = "{:%I:%M %p}";
        "tooltip" = true;
        "tooltip-format" = "<tt>{calendar}</tt>";
      };
      "memory" = {
        "interval" = 1;
        "format" = "󰻠 {percentage}%";
        "states" = { "warning" = 85; };
      };
      "cpu" = {
        "interval" = 1;
        "format" = "󰍛 {usage}%";
      };
      "mpd" = {
        "max-length" = 25;
        "format" = "<span foreground='#bb9af7'></span> {title}";
        "format-paused" = " {title}";
        "format-stopped" = "<span foreground='#bb9af7'></span>";
        "format-disconnected" = "";
        "on-click" = "mpc --quiet toggle";
        "on-click-right" = "mpc update; mpc ls | mpc add";
        "on-click-middle" = "kitty --class='ncmpcpp' ncmpcpp ";
        "on-scroll-up" = "mpc --quiet prev";
        "on-scroll-down" = "mpc --quiet next";
        "smooth-scrolling-threshold" = 5;
        "tooltip-format" =
          "{title} - {artist} ({elapsedTime:%M:%S}/{totalTime:%H:%M:%S})";
      };
      "network" = {
        "format-disconnected" = "󰯡 Disconnected";
        "format-ethernet" = "󰒢 Connected!";
        "format-linked" = "󰖪 {essid} (No IP)";
        "format-wifi" = "󰖩 ";
        "interval" = 1;
        "tooltip" = true;
        "tooltip-format" = "{essid}";
      };
      "custom/powermenu" = {
        "format" = "";
        "on-click" =
          "pkill rofi || ~/.config/rofi/powermenu/type-3/powermenu.sh";
        "tooltip" = false;
      };
      "tray" = {
        "icon-size" = 15;
        "spacing" = 5;
      };
    }];
  };
}
