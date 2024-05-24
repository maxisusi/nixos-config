{ config, pkgs, user, inputs, system,  ... }:

let
 neovimConfig = import ../modules/nixvim;
 nvim = inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule {
   inherit pkgs;
   module = neovimConfig;
 };
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = user;
  home.homeDirectory = "/home/${user}";


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
    _1password-gui
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
    
    # LANGUAGES
    nodenv

    # TIPEE

    # FONTS
    # (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
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
  home.sessionVariables = {
  #  EDITOR = "nvim";
  };

   # CONFIGUTATIONS
   programs.git = {
    enable = true;
    userName  = "maxisusi";
    userEmail = "maxbalej@proton.me";
    extraConfig = {
    	push = {autoSetupRemote = true;};
	pull = {rebase = true;};
  # TODO: Config 1password
	# gpg = {format = "ssh";};
	# commit = {gpgsign = true;};
    };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    shellAliases = { 
    # GENERALS
    ee = "exit";
    dps = "docker ps";

    # GIT
    gp = "git push";

    # TIPEE
    mu = "make up";
    md = "made down";
    mr = "make restart";
    mrb = "make destroy && make up";
    gcb = "git cherry -v develop $(git branch --show-current)"; 

    vi = "nvim";
    };
  };

programs.tmux = {
  enable = true;
  plugins = [
  	 pkgs.tmuxPlugins.dracula
  ];
    extraConfig = ''
    unbind C-b
    set -g prefix C-a

    set -g mode-keys vi
    bind-key -r C-h select-window -t :-
    bind-key -r C-l select-window -t :+
    # Set new panes to open in current directory

    bind c new-window -c "#{pane_current_path}"
    bind '"' split-window -c "#{pane_current_path}"
    bind % split-window -h -c "#{pane_current_path}"

    # Resize with mouse
    setw -g mouse on

  '';
};

  programs.kitty = {
    enable = true;
    theme = "Dracula";
    font = {
    	name = "JetBrainsMonoNL Nerd Font";
	size = 10.0;
    };
    shellIntegration = {
	enableFishIntegration = true;
    };
    settings = {
    	adjust_line_height = 2;
	initial_window_width = 920;
	initial_window_height = 1080;
	hide_window_decorations = "yes";
	window_border_width = 0;
    };
  };


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
