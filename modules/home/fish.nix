{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      zoxide init fish | source

      direnv hook fish | source
      set -g direnv_fish_mode eval_on_arrow
    '';
    shellAliases = {
      # GENERALS
      ee = "exit";
      dps = "docker ps";
      dcu = "docker compose up";
      dcd = "docker compose down";
      dcr = "docker compose restart";
      vi = "nvim";
      ns = "nix-shell --command fish";
      s = "kitten ssh";
      t = "tmux";
      tk = "tmux kill-server";
    };
  };
}
