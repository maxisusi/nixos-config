{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "sloth";
  version = "latest";

  src = fetchurl {
    url = "https://storage.googleapis.com/sloth-builds/latest/sloth-linux-amd64";
    sha256 = "sha256-DBPRS6xTE+OrKSPWCWLaO0vDiN4b2gButoTn77E/rjU=";
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

  meta = with lib; {
    description = "Manages tipee's infrastructure";
  };



}
