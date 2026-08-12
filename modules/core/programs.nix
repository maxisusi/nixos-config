{ inputs, pkgs, ... }: {
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = [ "max" ];
  };

  programs.hyprland = {
    enable = true;
    # set the flake package
    package =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

    xwayland.enable = true;

    systemd.setPath.enable = true;
  };
  nix.settings = {
    # Lets this user set restricted settings (substituters, trusted-public-keys)
    # from a flake's nixConfig.
    trusted-users = [ "root" "max" ];
    substituters = [
      "https://hyprland.cachix.org"
      # Pre-built Pi 5 kernel/firmware for the speedsoft SD image — without
      # this the kernel compiles under QEMU (hours).
      "https://nixos-raspberrypi.cachix.org"
      "https://nix-cache.tipee.cloud"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
      "nix-cache.tipee.cloud-1:wyyfWik+x7cpTODlztChPdYTWHEvrc200tLKES43CCE="
    ];
  };

  services.hypridle.enable = true;

  # Required by Quickshell's battery and power-profile indicators (UPower /
  # PowerProfiles D-Bus services). Waybar read battery from sysfs directly and
  # didn't need these.
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
}
