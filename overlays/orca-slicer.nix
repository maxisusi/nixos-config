# orca-slicer 2.3.2 in nixos-unstable ships an EGL-only GLEW with a GLX-only
# wxWidgets, so glewInit() always fails ("Missing GL version" in
# ~/.config/OrcaSlicer/log/) and the 3D bed never renders. Master fixed it
# (2.4.1, wxWidgets 3.3 with withEGL = true), so pull the package from a
# pinned master rev until the fix reaches nixos-unstable.
# ponytail: drop this overlay once `nix eval nixpkgs#orca-slicer.version` >= 2.4.1
final: prev:
let
  master = import
    (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/d194c57994767660a122f2bc701ef2b85ca1ede8.tar.gz";
      sha256 = "0z2gq6p8vq2v58fhf7ikhplxsxpznql7yz1k9nxkkk17v5jw0lj6";
    })
    {
      inherit (prev) system;
      config.allowUnfree = true;
    };
in
{
  # That master rev also ships the binary unwrapped (wrapGAppsHook3 didn't run:
  # bin/orca-slicer is the raw ELF), so GTK file dialogs abort on the missing
  # org.gtk.Settings.FileChooser gsettings schema. Wrap it ourselves.
  orca-slicer = master.symlinkJoin {
    name = "orca-slicer-${master.orca-slicer.version}";
    paths = [ master.orca-slicer ];
    nativeBuildInputs = [ master.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/orca-slicer \
        --prefix XDG_DATA_DIRS : "${master.gtk3}/share/gsettings-schemas/${master.gtk3.name}" \
        --prefix XDG_DATA_DIRS : "${master.gsettings-desktop-schemas}/share/gsettings-schemas/${master.gsettings-desktop-schemas.name}" \
        --set WEBKIT_DISABLE_COMPOSITING_MODE 1
    '';
  };
}
