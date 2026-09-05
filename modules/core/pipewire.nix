{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    # The GPU's HDA codec exposes one HDMI port profile at a time:
    # hdmi-stereo is the LG monitor, hdmi-stereo-extra1 the TV.
    wireplumber.extraConfig."51-nvidia-hdmi-tv"."monitor.alsa.rules" = [
      {
        matches = [ { "device.name" = "alsa_card.pci-0000_01_00.1"; } ];
        actions.update-props."device.profile" = "output:hdmi-stereo-extra1";
      }
    ];

    extraConfig.pipewire-pulse."50-cyberpunk-tv"."pulse.rules" = [
      {
        matches = [ { "application.name" = "~Cyberpunk.*"; } ];
        actions.update-props."target.object" = "alsa_output.pci-0000_01_00.1.hdmi-stereo-extra1";
      }
    ];
  };
}
