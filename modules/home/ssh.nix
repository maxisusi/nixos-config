{ pkgs, ... }:
let
  onePassPath = "/home/max/.1password/agent.sock";
  # Public half only; the private key lives in 1Password. Pinned so ssh does not offer every agent key.
  adminPub = pkgs.writeText "admin.pub" "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINpCusrWgvmHMGSxw7vr5jk1UbZb2ASjq6DRpGRs4jaO admin";
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."github.com" = {
      Hostname = "github.com";
      User = "git";
      IdentityAgent = onePassPath;
      SetEnv = {
        TERM = "xterm-256color";
      };
    };
    settings.locast = {
      Hostname = "83.228.193.102";
      User = "root";
      IdentityAgent = onePassPath;
      IdentitiesOnly = "yes";
      IdentityFile = "${adminPub}";
    };
  };
}
