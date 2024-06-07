{
  imports = [ (import ./hardware.nix) ] ++ [ (import ./user.nix) ]
    ++ [ (import ./pipewire.nix) ] ++ [ (import ./system.nix) ]
    ++ [ (import ./xserver.nix) ] ++ [ (import ./security.nix) ]
    ++ [ (import ./bootloader.nix) ] ++ [ (import ./programs.nix) ]
    ++ [ (import ./bash.nix) ] ++ [ (import ./services.nix) ];
}
