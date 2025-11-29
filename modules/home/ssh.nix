let onePassPath = "~/.1password/agent.sock";
in {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = true;
    extraConfig = ''
      Host *
          IdentityAgent ${onePassPath}
    '';
  };
}
