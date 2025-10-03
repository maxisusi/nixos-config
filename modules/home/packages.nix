{ pkgs, ... }: {
  nixpkgs.overlays = [
    (final: prev: {
      claude-code = prev.claude-code.overrideAttrs (oldAttrs: rec {
        version = "1.0.43";
        src = prev.fetchzip {
          url =
            "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
          hash = "sha256-MPnctLow88Muzd9h5c6w/u0tO4Umrl6YJcp/1/BTFD4=";
        };
        npmDepsHash =
          ""; # Set to empty first, then replace with hash from build error
      });
    })
  ];
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
    hoppscotch
    postman
    flameshot
    neofetch
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
    air
    xxd
    rsibreak
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
    ghidra
    gdb
    nasm
    wget
    meld
    wineWowPackages.stable
    winetricks
    firefox
    tomato-c
    claude-code
    thumbs
    elixir
    gemini-cli
    slurp
    hyprshot
    satty
    wiremix
    bluetui
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
