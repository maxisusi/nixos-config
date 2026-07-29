{ stdenvNoCC, lib, fetchurl, unzip, glibc }:

stdenvNoCC.mkDerivation rec {
  pname = "coderabbit-cli";
  version = "0.7.0";

  src = fetchurl {
    url = "https://cli.coderabbit.ai/releases/${version}/coderabbit-linux-x64.zip";
    hash = "sha256-o3A45u+lzFkTr2rO1VClgtnJzbkbSgSG+dNQ7wT6qqw=";
  };

  nativeBuildInputs = [ unzip ];
  sourceRoot = ".";

  # Bun-compiled binary: the embedded app lives at end-of-file, so patchelf
  # or strip corrupts it and it falls back to plain bun. Keep the file
  # byte-identical and launch it through the glibc loader instead.
  dontStrip = true;
  dontPatchELF = true;

  installPhase = ''
    install -Dm755 coderabbit $out/libexec/coderabbit
    mkdir -p $out/bin
    cat > $out/bin/coderabbit <<EOF
    #!/bin/sh
    exec ${glibc}/lib/ld-linux-x86-64.so.2 $out/libexec/coderabbit "\$@"
    EOF
    chmod +x $out/bin/coderabbit
    ln -s $out/bin/coderabbit $out/bin/cr
  '';

  meta = {
    description = "CodeRabbit AI code review CLI";
    homepage = "https://www.coderabbit.ai/cli";
    platforms = [ "x86_64-linux" ];
  };
}
