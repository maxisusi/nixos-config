{ pkgs, ... }: {
  home.packages = with pkgs; [
    oh-my-fish
    slack
    vscode
    ripgrep
    jq
    gnumake
    rsync
    tokei
    python3
    insomnia
    zoxide
    flameshot
    neofetch
    rustfmt
    cargo
    discord
    cinnamon.nemo-with-extensions
    imv
    mpv
    wl-clipboard
    poweralertd
    qalculate-gtk
    unzip
    wget
    xdg-utils
    xxd
    ncdu # disk space
    libnotify
  ];
}
