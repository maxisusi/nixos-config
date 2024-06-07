{
  programs.fish = {
    catppuccin.enable = true;
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      zoxide init fish | source
    '';
    shellAliases = {
      # GENERALS
      ee = "exit";
      dps = "docker ps";
      vi = "nvim";
      ns = "nix-shell --command fish";
    };
  };
}
