{
  security = {
    rtkit.enable = true;
    sudo.wheelNeedsPassword = false;
    pam.services.hyprlock = { };
    polkit.enable = true;
  };

}
