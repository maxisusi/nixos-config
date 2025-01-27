{ user, ... }: {

  home.username = user;
  home.homeDirectory = "/home/${user}";
  home.sessionVariables = { EDITOR = "nvim"; };
  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;
}
