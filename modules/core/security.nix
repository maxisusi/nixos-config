{
  security = {
    rtkit.enable = true;
    sudo.wheelNeedsPassword = false;
    polkit.enable = true;
  };

  # Provides the Secret Service D-Bus API that apps like 1Password need to
  # persist secrets (e.g. the 2FA token). This module also wires
  # pam_gnome_keyring into the `login` PAM service, which SDDM substacks, so
  # the keyring is unlocked with the login password. Note: setting
  # security.pam.services.sddm.enableGnomeKeyring directly does NOT work —
  # the SDDM module sets useDefaultRules = false, which silently drops it.
  services.gnome.gnome-keyring.enable = true;
}
