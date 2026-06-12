{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "maxisusi";
        email = "maxbalej@proton.me";
        # "Github SSH" key stored in 1Password
        signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJJJ6b/1CdEAgUkkOFUBkvcsxd6Dj50S8jNJfTDQ/Vt2";
      };
      push = {
        autoSetupRemote = true;
      };
      pull = {
        rebase = true;
      };
      gpg = {
        format = "ssh";
      };
      # Sign through 1Password directly instead of the ssh-agent socket
      gpg."ssh".program = "${pkgs._1password-gui}/bin/op-ssh-sign";
      commit = {
        gpgsign = true;
      };
      rerere = {
        enabled = true;
      };
    };
  };
}
