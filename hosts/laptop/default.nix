{ pkgs, ... }: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  networking.hostName = "laptop"; # Define your hostname.

  # Turns on the Ozone Wayland backend 
  environment = {
    variables = { NIXOS_OZONE_WL = 1; };
    systemPackages = with pkgs; [ google-chrome ];
  };

}
