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
    plasma5Packages.kdeconnect-kde
    vscode-extensions.vadimcn.vscode-lldb.adapter
    direnv
    obsidian
    atuin
    zsh
    go
    air
    xxd
    rsibreak
    wl-clipboard
    # (callPackage ../../packages/sloth { })
    yazi
    fd
    fzf
    poppler
    imagemagick
    p7zip
    ffmpeg
    tmuxifier
    tree
    commitizen
    lsof
    gnome-calculator
    ghidra
    gdb
    nasm
  ];
  services.udiskie = {
    enable = true;
    settings = {
      # workaround for
      # https://github.com/nix-community/home-manager/issues/632
      program_options = {
        # replace with your favorite file manager
        file_manager = "${pkgs.nemo-with-extensions}/bin/nemo";
      };
    };
  };

}
