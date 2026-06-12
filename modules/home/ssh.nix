let
  onePassPath = "/home/max/.1password/agent.sock";
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
  };
}
