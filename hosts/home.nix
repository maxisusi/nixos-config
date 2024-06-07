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
    flameshot
    neofetch
    # Rust related
    rustfmt
    cargo

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
