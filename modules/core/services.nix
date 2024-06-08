{
  services.libinput = {
    touchpad.naturalScrolling = true;
    mouse.naturalScrolling = true;
  };
  services.printing.enable = true;
  services = {
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
    dbus.enable = true;
    fstrim.enable = true;
  };

  services.displayManager.sddm.enable = true;

}
