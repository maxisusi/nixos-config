{ pkgs, ... }: {
  services.libinput = {
    touchpad.naturalScrolling = true;
    mouse.naturalScrolling = true;
  };
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brlaser pkgs.hplip ];
  services.udev = {
    extraRules = ''SUBSYSTEM=="usbmon", GROUP="wireshark", MODE="0640" '';
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # The kernel OOM killer ranks by oom_score, which Electron inflates
  # (Slack runs at oom_score_adj=300), so it kept killing Slack while the real
  # hog survived. With no swap the box also thrashes before the kernel acts at
  # all. earlyoom fires at 10% available RAM and --sort-by-rss targets the
  # actual memory hog.
  services.earlyoom = {
    enable = true;
    enableNotifications = true;
    extraArgs = [ "--sort-by-rss" ];
  };
}
