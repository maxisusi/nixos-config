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
    vlc
    libreoffice
    catppuccin-kde
    kdeconnect
    vscode-extensions.vadimcn.vscode-lldb.adapter
    direnv
    obsidian
    atuin
  ];
}
