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
    zoxide
    rustfmt
    cargo
    discord
    vlc
    libreoffice
    vscode-extensions.vadimcn.vscode-lldb.adapter
    direnv
    obsidian
    atuin
    zsh
    go
    wl-clipboard
    yazi
    fd
    fzf
    poppler
    imagemagick
    p7zip
    ffmpeg
    tmuxifier
    tree
    lsof
    gnome-calculator
    gdb
    wget
    wineWowPackages.stable
    winetricks
    firefox
    tomato-c
    claude-code
    gemini-cli
    slurp
    hyprshot
    satty
    wiremix
    bluetui
    jocalsend
    yaak
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
