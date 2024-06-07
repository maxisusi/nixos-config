{ pkgs ? import <nixpkgs> { } }:
let
  gdk = pkgs.google-cloud-sdk.withExtraComponents
    (with pkgs.google-cloud-sdk.components; [ gke-gcloud-auth-plugin ]);
in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    yarn
    tmuxifier
    zsh
    gnumake
    rsync
    nodenv
    gdk
    (callPackage ../../packages/sloth { })
    nodejs
  ];

  shellHook = ''
    npm config set prefix $TMPDIR # Store the global dir in a temporary folder to install global npm packages
    npm i -g @styled/typescript-styled-plugin typescript-styled-plugin
    # Check if prepare-commit-msg is inside tipee on .git/hooks
    if [ ! -f /home/max/Documents/dev/tipee/.git/hooks/prepare-commit-msg ]; then
      cp ./prepare-commit-msg /home/max/Documents/dev/tipee/.git/hooks/prepare-commit-msg 
    fi

    # Add auto login user id to .env.local
    if [ ! -f /home/max/Documents/dev/tipee/.env.local ]; then
      echo "AUTO_LOGIN_USER_ID=1" > /home/max/Documents/dev/tipee/.env.local
    fi

    tmuxifier load-session ./tipee-run.sh # Load tipee session
  '';
}
