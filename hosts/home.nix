{ pkgs, user, inputs, system, ... }:
let
  neovimConfig = import ../modules/nixvim;
  nvim = inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule {
    inherit pkgs;
    module = neovimConfig;
  };
  # gdk = pkgs.google-cloud-sdk.withExtraComponents
  #   (with pkgs.google-cloud-sdk.components; [ gke-gcloud-auth-plugin ]);
  onePassPath = "~/.1password/agent.sock";
  startupScript = pkgs.writeShellScriptBin "start" ''
    lxqt-policykit-agent &
    waybar &
    nm-applet &
    wl-clip-persist --clipboard both &
  '';
in {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = user;
  home.homeDirectory = "/home/${user}";
  catppuccin.flavor = "mocha";
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  nixpkgs.config.allowUnfree = true;
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # TERMINAL
    kitty
    oh-my-fish
    fish

    # PROGRAMS
    slack
    vscode
    # nvim
    nvim

    # TOOLS
    ripgrep
    jq
    git
    cargo
    rustc
    bat
    gnumake
    rsync
    lazygit
    tmux
    tmuxifier
    tokei
    python3
    insomnia
    zoxide
    starship
    # Hyprland utils
    dolphin
    rofi
    pamixer
    networkmanagerapplet
    blueman
    brightnessctl
    wl-clip-persist
    # Tipee
    # gdk
  ];
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/max/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = { EDITOR = "nvim"; };

  programs.lazygit = {
    enable = true;
    catppuccin.enable = true;
  };

  # CONFIGUTATIONS
  wayland.windowManager.hyprland = {
    catppuccin.enable = true;
    enable = true;
    settings = {
      "$mod" = "SUPER";
      "$terminal" = "kitty";
      "$fileManager" = "dolphin";
      "$menu" = "rofi -show drun";

      general = {
        gaps_in = 0;
        gaps_out = 10;
        border_size = 1;
        layout = "dwindle";
        resize_on_border = true;
        "col.active_border" = "rgb(cba6f7) rgb(94e2d5) 45deg";
        "col.inactive_border" = "0x00000000";
        border_part_of_window = false;
        no_border_on_floating = false;
      };
      decoration = {
        rounding = 3;
        drop_shadow = true;
        shadow_range = 4;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };

      };
      exec-once = "${startupScript}/bin/start";
      monitor = [
        "desc:Chimei Innolux Corporation 0x143F,highrr,0x0,1"
        "desc:LG Electronics LG HDR WQHD+ 307NTYTE5938,preferred,0x-1600,1" # Home monitor
        ",preferred,auto,1" # Random monitor
      ];
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      misc = {
        disable_autoreload = true;
        disable_hyprland_logo = true;
        always_follow_on_dnd = true;
        layers_hog_keyboard_focus = true;
        animate_manual_resizes = false;
        enable_swallow = true;
        focus_on_activate = true;
      };

      bindm = [ "$mod, mouse:272, movewindow" "$mod, mouse:273, resizewindow" ];
      bind = [
        "$mod, Q, exec, $terminal"
        "$mod, M, exit"

        "$mod, C, killactive"
        "$mod, J, togglesplit"
        "$mod, F, exec, $menu"
        "$mod, v, togglefloating"
        "$mod, E, exec, $fileManager"
        "$mod, P, pseudo"
        "$mod, J, togglesplit"

        # Change focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # window control
        "$mod SHIFT, left, movewindow, l"
        "$mod SHIFT, right, movewindow, r"
        "$mod SHIFT, up, movewindow, u"
        "$mod SHIFT, down, movewindow, d"
        "$mod CTRL, left, resizeactive, -80 0"
        "$mod CTRL, right, resizeactive, 80 0"
        "$mod CTRL, up, resizeactive, 0 -80"
        "$mod CTRL, down, resizeactive, 0 80"
        "$mod ALT, left, moveactive,  -80 0"
        "$mod ALT, right, moveactive, 80 0"
        "$mod ALT, up, moveactive, 0 -80"
        "$mod ALT, down, moveactive, 0 80"

        # Britghtness
        ",XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        "$mod, XF86MonBrightnessUp, exec, brightnessctl set 100%+"
        "$mod, XF86MonBrightnessDown, exec, brightnessctl set 100%-"
        # Volume
        ",XF86AudioRaiseVolume, exec, pamixer -i 5"
        ",XF86AudioLowerVolume, exec, pamixer -d 5"
        "$mod, XF86AudioRaiseVolume, exec, pamixer -i 10"
        "$mod, XF86AudioLowerVolume, exec, pamixer -d 10"
        # Mute Audio
        ",XF86AudioMute, exec, pamixer -t"
        # Mute micro
        ",XF86AudioMicMute, exec, pamixer --default-source -t"

      ] ++ (
        # workspaces
        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (builtins.genList (x:
          let
            ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
          in [
            "$mod, ${ws}, workspace, ${toString (x + 1)}"
            "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
          ]) 10));
      input = {
        kb_layout = "ch";
        kb_variant = "fr";
        touchpad = {
          natural_scroll = true;
          middle_button_emulation = false;
          "tap-to-click" = false;
        };
        follow_mouse = 1;
      };
      animations = {
        enabled = true;
        bezier = [
          "fluent_decel, 0, 0.2, 0.4, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
          "easeOutCubic, 0.33, 1, 0.68, 1"
          "easeinoutsine, 0.37, 0, 0.63, 1"
        ];
        animation = [
          # Windows
          "windowsIn, 1, 3, easeOutCubic, popin 30%" # window open
          "windowsOut, 1, 3, fluent_decel, popin 70%" # window close.
          "windowsMove, 1, 2, easeinoutsine, slide" # everything in between, moving, dragging, resizing.

          # Fade
          "fadeIn, 1, 3, easeOutCubic" # fade in (open) -> layers and windows
          "fadeOut, 1, 2, easeOutCubic" # fade out (close) -> layers and windows
          "fadeSwitch, 0, 1, easeOutCirc" # fade on changing activewindow and its opacity
          "fadeShadow, 1, 10, easeOutCirc" # fade on changing activewindow for shadows
          "fadeDim, 1, 4, fluent_decel" # the easing of the dimming of inactive windows
          "border, 1, 2.7, easeOutCirc" # for animating the border's color switch speed
          "borderangle, 1, 30, fluent_decel, once" # for animating the border's gradient angle - styles: once (default), loop
          "workspaces, 1, 4, easeOutCubic, fade" # styles: slide, slidevert, fade, slidefade, slidefadevert
        ];
      };
      windowrulev2 = [ "stayfocused,class:(rofi)" ];
    };
  };

  programs.starship = {
    enable = true;
    catppuccin.enable = true;
  };

  programs.git = {
    enable = true;
    userName = "maxisusi";
    userEmail = "maxbalej@proton.me";
    extraConfig = {
      push = { autoSetupRemote = true; };
      pull = { rebase = true; };
      gpg = { format = "ssh"; };
      gpg."ssh".program = "${pkgs._1password-gui}/bin/op-ssh-sign";
      commit = { gpgsign = true; };
      user = {
        signingkey =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJJJ6b/1CdEAgUkkOFUBkvcsxd6Dj50S8jNJfTDQ/Vt2";
      };
    };
  };

  programs.rofi = {
    enable = true;
    catppuccin.enable = true;
  };
  programs.waybar = {
    enable = true;
    systemd = {
      enable = false;
      target = "graphical-session.target";
    };
    style = ''
             * {
               font-family: "JetBrainsMono Nerd Font";
               font-size: 12pt;
               font-weight: bold;
               border-radius: 8px;
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
               margin-left: 5px;
               margin-right: 5px;
               margin-top: 5px;
               background-color: #1e1e2a;
               padding: 3px;
               padding-left:8px;
               border: 2px none #33ccff;
             }
       #workspaces {
               padding-left: 0px;
               padding-right: 4px;
             }
       #workspaces button {
               padding-top: 5px;
               padding-bottom: 5px;
               padding-left: 6px;
               padding-right: 6px;
             }
       #workspaces button.active {
               background-color: rgb(181, 232, 224);
               color: rgb(26, 24, 38);
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
             /* #mode { */
             /* 	margin-left: 10px; */
             /* 	background-color: rgb(248, 189, 150); */
             /*     color: rgb(26, 24, 38); */
             /* } */
       #memory {
               color: rgb(181, 232, 224);
             }
       #cpu {
               color: rgb(245, 194, 231);
             }
       #clock {
               color: rgb(217, 224, 238);
             }
      /* #idle_inhibitor {
               color: rgb(221, 182, 242);
             }*/
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
      modules-left =
        [ "custom/launcher" "temperature" "mpd" "custom/cava-internal" ];
      modules-center = [ "clock" ];
      modules-right = [
        "pulseaudio"
        "backlight"
        "memory"
        "cpu"
        "battery"
        "network"
        "custom/powermenu"
        "tray"
      ];
      "custom/launcher" = {
        "format" = " ";
        "on-click" = "pkill rofi || rofi2";
        "on-click-middle" = "exec default_wall";
        "on-click-right" = "exec wallpaper_random";
        "tooltip" = false;
      };
      "custom/cava-internal" = {
        "exec" = "sleep 1s && cava-internal";
        "tooltip" = false;
      };
      "pulseaudio" = {
        "scroll-step" = 1;
        "format" = "{icon} {volume}% {format_source}";
        "format-muted" = "󰖁 Muted {format_source}";
        "format-source" = "";
        "format-source-muted" = "";
        "format-icons" = { "default" = [ "" "" "" ]; };
        "on-click" = "pamixer -t";
        "tooltip" = false;
      };
      "battery" = {
        "interval" = 60;
        "format" = "{icon} {capacity}%";
        "format-icons" = [ "" "" "" "" ];
      };
      "clock" = {
        "interval" = 1;
        "format" = "{:%I:%M %p  %A %b %d}";
        "tooltip" = true;
        "tooltip-format" = ''
          {=%A; %d %B %Y}
          <tt>{calendar}</tt>'';
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
        "format-wifi" = "󰖩 {essid}";
        "interval" = 1;
        "tooltip" = false;
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

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
          IdentityAgent ${onePassPath}
    '';
  };

  programs.fish = {
    catppuccin.enable = true;
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      zoxide init fish | source
    '';
    shellAliases = {
      # GENERALS
      ee = "exit";
      dps = "docker ps";
      vi = "nvim";
      ns = "nix-shell --command fish";
    };
  };

  programs.tmux = {
    enable = true;
    catppuccin = {
      enable = true;
      extraConfig = ''
        set -g @catppuccin_status_modules_right "application session cpu"
      '';

    };
    plugins = with pkgs; [
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.sensible
      tmuxPlugins.cpu
    ];
    extraConfig = ''
      # Unbind default C-b command
      unbind C-b
      set -g prefix C-a

      # Fixing strikethrough not appearing on tmux with neovim
      set -g default-terminal "xterm-kitty"
      set -ga terminal-overrides ",xterm-256color:Tc,alacritty:RGB"
      set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0

      # Reload config
      unbind r
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "tmux.conf reloaded..."

      # Set new panes to open in current directory
      bind c new-window -c "#{pane_current_path}"
      bind '"' split-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"

      # Restoring clear screen
      bind C-l send-keys 'C-l'

      # Resize with mouse
      setw -g mouse on


    '';
  };

  programs.kitty = {
    enable = true;
    catppuccin.enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 10.0;
    };
    shellIntegration = { enableFishIntegration = true; };
    settings = {
      adjust_line_height = 2;
      initial_window_width = 920;
      initial_window_height = 1080;
      hide_window_decorations = "yes";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
