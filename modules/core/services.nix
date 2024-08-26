{ pkgs, ... }: {
  services.libinput = {
    touchpad.naturalScrolling = true;
    mouse.naturalScrolling = true;
  };
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brlaser ];

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
