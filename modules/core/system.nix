{ pkgs, ... }: {
  time.timeZone = "Europe/Zurich";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_MONETARY = "fr_CH.UTF-8";
      LC_TIME = "fr_CH.UTF-8";
    };
  };

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    # Automatic garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "23.11"; # Did you read the comment?

  networking.networkmanager.enable = true;

  # Opening ports for KDE Connect
  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [{
      from = 1714;
      to = 1764;
    } # KDE Connect
      ];
    allowedUDPPortRanges = [{
      from = 1714;
      to = 1764;
    } # KDE Connect
      ];
  };

  environment = {
    sessionVariables = { FLAKE = "/home/max/.config/flakes/nixos-config"; };
    variables = {
      RUST_BACKTRACE = 1;
      TERMINAL = "kitty";
      EDITOR = "nvim";
      VISUAL = "vim";
    };
    systemPackages = with pkgs; [
      google-chrome
      firefox
      docker
      docker-compose
      wally-cli
      nh
      keymapp

    ];
  };

  fonts.packages = with pkgs;
    [ (nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];

  virtualisation.docker.enable = true;

}
