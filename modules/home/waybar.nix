{ ... }: {
  programs.waybar = {
    enable = true;
    systemd = {
      enable = false;
      target = "graphical-session.target";
    };
    style = ''
              * {
                font-family: "JetBrainsMono Nerd Font";
                font-size: 10pt;
                font-weight: bold;
                /* border-radius: 8px; */
                transition-property: background-color;
                transition-duration: 0.5s;
              }
              @keyframes blink_red {
                to {
                  background-color: rgb(242, 143, 173);
                  color: rgb(26, 24, 38);
                }
              }
              .warning, .critical, .urgent {
                animation-name: blink_red;
                animation-duration: 1s;
                animation-timing-function: linear;
                animation-iteration-count: infinite;
                animation-direction: alternate;
              }
              window#waybar {
                background-color: transparent;
              }
              window > box {
                background-color: rgba(30, 30, 42,0.2);
                opacity: 0.7;
                padding: 2px;
                padding-left: 8px;
                border: 2px none #33ccff;
              }
        #workspaces {
                padding-left: 0px;
                padding-right: 4px;
              }
        #workspaces button {
                padding: 2px;
              }
        #workspaces button.active {
                background-color: #E49B5D;
                color: #292522;
              }
        #workspaces button.urgent {
                color: rgb(26, 24, 38);
              }
        #workspaces button:hover {
                background-color: rgb(248, 189, 150);
                color: rgb(26, 24, 38);
              }
              tooltip {
                background: rgb(48, 45, 65);
              }
              tooltip label {
                color: rgb(217, 224, 238);
              }
        #custom-launcher {
                font-size: 20px;
                padding-left: 8px;
                padding-right: 6px;
                color: #7ebae4;
              }
        #mode, #clock, #memory, #temperature,#cpu,#mpd, #custom-wall, #temperature, #backlight, #pulseaudio, #network, #battery, #custom-powermenu, #custom-cava-internal {
                padding-left: 10px;
                padding-right: 10px;
              }
       #mode { 
        margin-left: 10px; 
        background-color: rgb(248, 189, 150); 
        color: rgb(26, 24, 38); 
      } 
        #memory {
                color: rgb(181, 232, 224);
              }
        #cpu {
                color: rgb(245, 194, 231);
              }
        #clock {
                color: rgb(217, 224, 238);
              }
        #idle_inhibitor {
                color: rgb(221, 182, 242);
              }
        #custom-wall {
                color: #33ccff;
           }
        #temperature {
                color: rgb(150, 205, 251);
              }
        #backlight {
                color: rgb(248, 189, 150);
              }
        #pulseaudio {
                color: rgb(245, 224, 220);
              }
        #network {
                color: #ABE9B3;
              }
        #network.disconnected {
                color: rgb(255, 255, 255);
              }
        #custom-powermenu {
                color: rgb(242, 143, 173);
                padding-right: 8px;
              }
        #tray {
                padding-right: 8px;
                padding-left: 10px;
              }
        #mpd.paused {
                color: #414868;
                font-style: italic;
              }
        #mpd.stopped {
                background: transparent;
              }
        #mpd {
                color: #c0caf5;
              }
        #custom-cava-internal{
                font-family: "Hack Nerd Font" ;
                color: #33ccff;
              }
    '';
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
