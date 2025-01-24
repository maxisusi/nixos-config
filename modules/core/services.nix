{ pkgs, ... }: {
  services.libinput = {
    touchpad.naturalScrolling = true;
    mouse.naturalScrolling = true;
  };
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brlaser ];
  services.udev = {
    extraRules = ''SUBSYSTEM=="usbmon", GROUP="wireshark", MODE="0640" '';
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
