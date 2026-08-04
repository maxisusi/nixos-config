{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "desktop";

  networking.interfaces.eno1.wakeOnLan = {
    enable = true;
    policy = [ "magic" ];
  };
  networking.firewall.allowedUDPPorts = [ 9 ];

  # Steam and optimisations
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  boot = {
    # Build/deploy aarch64 closures (speedsoft Pi 5 SD image) via QEMU.
    binfmt.emulatedSystems = [ "aarch64-linux" ];

    # Nvidia GPU kernel module.
    # https://search.nixos.org/options?channel=24.05&show=boot.extraModulePackages
    # https://search.nixos.org/options?channel=24.05&show=boot.initrd.kernelModules
    # latest (610.x): beta 595.45.04 fails to compile against zen kernel 7.1.4
    extraModulePackages = [ config.boot.kernelPackages.nvidia_x11_latest ];
    initrd.kernelModules =
      [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

    # Parameters added to the Kernel command line. Here, used to make suspend work properly.
    # https://search.nixos.org/options?channel=24.05&show=boot.kernelParams
    kernelParams = [
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      "nvidia-drm.fbdev=1"
      "nvidia-drm.modeset=1"
    ];
  };

  environment = {
    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATH =
        "\${HOME}/.steam/root/compatibilitytools.d";
    };
    systemPackages = with pkgs; [
      protonup-ng
      # Don't install nvidia_x11 directly - it conflicts with hardware.nvidia.package
      google-chrome
    ];
  };

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.graphics.extraPackages = with pkgs; [ nvidia-vaapi-driver libva ];
  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = true;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = true;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  # CalDigit TS3 Plus dock: its two Fresco Logic FL1100 xHCI controllers
  # (1b73:1100) log "xHCI host controller not responding, assume dead" ~11s
  # into boot when the idle Thunderbolt tunnel is runtime power-gated to
  # D3cold, so dock USB only works after a manual replug. Pin them in D0 to
  # keep the link alive. (Desktop — no battery cost to disabling runtime PM.)
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x1b73", ATTR{device}=="0x1100", ATTR{power/control}="on", ATTR{d3cold_allowed}="0"
  '';

}
