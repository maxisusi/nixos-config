let
  onePassPath = "/home/max/.bitwarden-ssh-agent.sock";
in
{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host github.com
          HostName github.com
          User git
          IdentityAgent ${onePassPath}
          SetEnv TERM=xterm-256color
    '';
  };
}
