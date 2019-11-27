{ pkgs, ... }:

with pkgs;
let
  libfixposix = if stdenv.isDarwin then
    pkgs.callPackage ../libfixposix { }
  else
    pkgs.libfixposix;
  next-pyqt = pkgs.callPackage ./next-pyqt.nix { };
in stdenv.mkDerivation rec {
  name = "next";
  version = "9d65598a0911a09e3befcad65444763a51527913";

  src = fetchurl {
    url = "https://github.com/tviti/next/archive/${version}.tar.gz";
    sha256 = "0ba7i7yn6ya7qdc768z4z23x2zyq78w67pgs6abav2jyxp83qy2n";
  };

  # Stripping destroys the generated SBCL image
  dontStrip = true;

  nativeBuildInputs = [ sbcl makeWrapper libfixposix ];
  buildInputs = [ next-pyqt curl cacert dbus pass ];

  # Make sure this runs the correct python env
  configurePhase = ''
    substituteInPlace ./ports/pyqt-webengine/next-pyqt-webengine.py \
        --replace "#!/usr/bin/env python3" "#!${next-pyqt.out}/bin/python"
  '';

  buildPhase = if stdenv.isDarwin then ''
    export HOME=$TMP
    make app-bundle
  '' else ''
    make next
  '';

  installPhase = if stdenv.isDarwin then ''
    mkdir -p $out/Applications
    mkdir -p $out/bin
    mv ./Next.app $out/Applications/Next.app
    ln -s $out/Applications/Next.app/Contents/MacOS/next $out/bin/next
  '' else ''
    install -D -m0755 next $out/bin/next
  '';

  meta = with stdenv; { platforms = [ "x86_64-linux" "x86_64-darwin" ]; };

}
