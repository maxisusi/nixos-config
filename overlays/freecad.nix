# FreeCAD 1.1.1 segfaults on startup during workbench autoload. Coin3D's
# libCoin.so statically embeds an OLD expat and exports its XML_* symbols
# globally (XML_ParserCreate, XML_SetHashSalt) but NOT XML_SetHashSalt16Bytes.
# Python 3.14's _elementtree (patched by cpython gh-149018) creates a parser via
# the globally-shadowed old XML_ParserCreate (8-byte salt struct) but then calls
# XML_SetHashSalt16Bytes from the real libexpat 2.8.2 (Coin lacks it), writing
# 16 bytes into an 8-byte field -> heap overflow -> SIGSEGV.
#
# Preloading the real libexpat makes ALL XML_* symbols resolve to one consistent
# 2.8.2, so the parser struct and the salt call agree.
# ponytail: drop this once coin3d stops leaking a static expat, or freecad drops python3.14.
final: prev:
{
  freecad = prev.symlinkJoin {
    name = "freecad-${prev.freecad.version}";
    paths = [ prev.freecad ];
    nativeBuildInputs = [ prev.makeWrapper ];
    postBuild = ''
      for bin in $out/bin/freecad $out/bin/freecadcmd $out/bin/FreeCAD; do
        [ -e "$bin" ] && wrapProgram "$bin" \
          --prefix LD_PRELOAD : "${prev.expat}/lib/libexpat.so.1"
      done
    '';
  };
}
