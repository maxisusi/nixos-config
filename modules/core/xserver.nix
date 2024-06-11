{ pkgs, ... }: {
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    # KDE
    # desktopManager.plasma5.enable = true;
    # excludePackages = with pkgs.libsForQt5; [ spectacle ];
    # services.displayManager.sddm.enable = true;
  };
  # GNOME fixing display manager
  nixpkgs.overlays = [
    # GNOME 46: triple-buffering-v4-46
    (final: prev: {
      gnome = prev.gnome.overrideScope (gnomeFinal: gnomePrev: {
        mutter = gnomePrev.mutter.overrideAttrs (old: {
          src = pkgs.fetchFromGitLab {
            domain = "gitlab.gnome.org";
            owner = "vanvugt";
            repo = "mutter";
            rev = "triple-buffering-v4-46";
            hash = "sha256-fkPjB/5DPBX06t7yj0Rb3UEuu5b9mu3aS+jhH18+lpI=";
          };
        });
      });
    })
  ];

  # Disable packages from gnome
  environment.gnome.excludePackages = with pkgs.gnome; [
    cheese # webcam tool
    gnome-music
    gnome-terminal
    epiphany # web browser
    geary # email reader
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
  ];
}
