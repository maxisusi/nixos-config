{ pkgs, ... }: {
  services.xserver = {
    enable = true;

    #  -- KDE SETTINGS --
    desktopManager.plasma5.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    xkb = { options = "ctrl:nocaps"; };

    # -- GNOME SETTINGS --
    # displayManager.gdm.enable = true;
    # desktopManager.gnome = {
    #   enable = true;
    #   extraGSettingsOverrides = ''
    #     # Change default background
    #     [org.gnome.desktop.background]
    #     picture-uri='file://${../../wallpapers/purplesky.png}' 
    #   '';
    # };
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [ spectacle ];
  # nixpkgs.overlays = [
  #   # GNOME 46: triple-buffering-v4-46
  #   (final: prev: {
  #     gnome = prev.gnome.overrideScope (gnomeFinal: gnomePrev: {
  #       mutter = gnomePrev.mutter.overrideAttrs (old: {
  #         src = pkgs.fetchFromGitLab {
  #           domain = "gitlab.gnome.org";
  #           owner = "vanvugt";
  #           repo = "mutter";
  #           rev = "triple-buffering-v4-46";
  #           hash = "sha256-fkPjB/5DPBX06t7yj0Rb3UEuu5b9mu3aS+jhH18+lpI=";
  #         };
  #       });
  #     });
  #   })
  # ];

  # Disable packages from gnome
  # environment.gnome.excludePackages = with pkgs.gnome; [
  #   cheese # webcam tool
  #   gnome-music
  #   gnome-terminal
  #   epiphany # web browser
  #   geary # email reader
  #   totem # video player
  #   tali # poker game
  #   iagno # go game
  #   hitori # sudoku game
  #   atomix # puzzle game
  # ];
}
