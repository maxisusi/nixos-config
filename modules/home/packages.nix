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
    hoppscotch
    postman
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
    wget
    meld
    wineWowPackages.stable
    winetricks
    firefox
    tomato-c
  ];

  programs.firefox = {
    enable = true;
    profiles = {
      max = {
        bookmarks = {
          force = true;
          settings = [
            {
              name = "wikipedia";
              tags = [ "wiki" ];
              keyword = "wiki";
              url =
                "https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go";
            }
            {
              name = "kernel.org";
              url = "https://www.kernel.org";
            }
            {
              name = "Nix sites";
              toolbar = true;
              bookmarks = [
                {
                  name = "homepage";
                  url = "https://nixos.org/";
                }
                {
                  name = "wiki";
                  tags = [ "wiki" "nix" ];
                  url = "https://wiki.nixos.org/";
                }
              ];
            }
          ];
        };
      };
    };
  };

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
