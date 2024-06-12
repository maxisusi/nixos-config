{ pkgs, ... }: {
  programs.git = {
    enable = true;
    userName = "maxisusi";
    userEmail = "maxbalej@proton.me";
    extraConfig = {
      push = { autoSetupRemote = true; };
      pull = { rebase = true; };
      gpg = { format = "ssh"; };
      gpg."ssh".program = "${pkgs._1password-gui}/bin/op-ssh-sign";
      commit = { gpgsign = true; };
      user = {
        signingkey =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJJJ6b/1CdEAgUkkOFUBkvcsxd6Dj50S8jNJfTDQ/Vt2";
      };
      rerere = { enabled = true; };
    };
  };
}
