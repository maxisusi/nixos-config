{
  stdenv,
  lib,
  requireFile,
  autoPatchelfHook,
  alsa-lib,
  libGL,
  wayland,
  libxkbcommon,
  dbus,
  libxcb,
}:

stdenv.mkDerivation {
  pname = "codelord";
  version = "0-unstable-2026-08-03";

  # Paid app behind a Polar license portal — no public download URL, and the
  # tarball must stay out of this (public) repo. Download it, then:
  #   nix-store --add-fixed sha256 codelord-linux-x64.tar.gz
  # A copy is kept at ~/.local/share/codelord/ to re-add after a GC.
  src = requireFile {
    name = "codelord-linux-x64.tar.gz";
    hash = "sha256-fkSOSjSU8xodHWtNXRN/WSNZ9tYxFB3m2Bt1cqFBwQ4=";
    url = "https://polar.sh/codelord/portal";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [
    stdenv.cc.cc.lib
    alsa-lib
  ];

  # dlopen'd, so autoPatchelfHook can't see them in DT_NEEDED. List taken from
  # `strings codelord | grep -o 'lib.*\.so'`. Add here if it dies at startup
  # with a missing .so.
  runtimeDependencies = [
    libGL
    wayland
    libxkbcommon
    dbus
    libxcb
  ];

  installPhase = "install -Dm755 codelord $out/bin/codelord";

  meta = {
    description = "Codelord code editor";
    homepage = "https://polar.sh/codelord";
    platforms = [ "x86_64-linux" ];
  };
}
