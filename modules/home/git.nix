{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "maxisusi";
    userEmail = "maxbalej@proton.me";
    extraConfig = {
      push = {
        autoSetupRemote = true;
      };
      pull = {
        rebase = true;
      };
      gpg = {
        format = "ssh";
      };
      # gpg."ssh".program = "${pkgs.bitwarden-desktop}";
      commit = {
        gpgsign = true;
      };
      user = {
        signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDmxXgfYh+lDl8mZxGvrh+HTjIK4FsN5m0/o919c44vD";
      };
      rerere = {
        enabled = true;
      };
    };
  };
}
