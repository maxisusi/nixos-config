{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "sloth";
  version = "latest";

  src = fetchurl {
    url =
      "https://storage.googleapis.com/sloth-builds/latest/sloth-linux-amd64";
    sha256 = "sha256-mvlBBYMlUiusrYTQpp+vaAlwVXZHEclYVT22QkVJOU4=";
  };

  dontBuild = true;

  unpackPhase = ''
    cp $src ${pname}
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ${pname} $out/bin/${pname}
    chmod +x $out/bin/${pname}
  '';

  meta = { description = "Manages tipee's infrastructure"; };

}
