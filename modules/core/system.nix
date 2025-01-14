{ pkgs, lib, ... }: {
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

  documentation.enable = true;
  documentation.man.enable = true;
  documentation.dev.enable = true;

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
      NIXOS_OZONE_WL = 1;
      RUST_BACKTRACE = 1;
      TERMINAL = "kitty";
      EDITOR = "nvim";
      VISUAL = "vim";
      MANPAGER = "nvim +Man!";
      MANWIDTH = "999";
    };
    systemPackages = with pkgs; [
      google-chrome
      firefox
      docker
      docker-compose
      wally-cli
      nh
      keymapp
      gcc
      clang
      linux-manual
      man-pages
      man-pages-posix
      man-db
    ];
  };

  # fonts.packages = with pkgs;
  #   [ (nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];
  #
  fonts.packages = [ ] ++ builtins.filter lib.attrsets.isDerivation
    (builtins.attrValues pkgs.nerd-fonts);

  virtualisation.docker.enable = true;

}
