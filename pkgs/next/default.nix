{ pkgs, ... }:

with pkgs;
let
  libfixposix = pkgs.callPackage ../libfixposix { };
  next-pyqt = pkgs.callPackage ./next-pyqt.nix { };
in stdenv.mkDerivation rec {
  name = "next-pyqt";
  version = "9d65598a0911a09e3befcad65444763a51527913";

  src = fetchurl {
    url = "https://github.com/tviti/next/archive/${version}.tar.gz";
    sha256 = "0ba7i7yn6ya7qdc768z4z23x2zyq78w67pgs6abav2jyxp83qy2n";
  };

  # Stripping destroys the generated SBCL image
  dontStrip = true;

  nativeBuildInputs =
    [ sbcl makeWrapper libfixposix ];

  buildInputs =  [ next-pyqt curl cacert dbus pass ];

  configurePhase = ''
    substituteInPlace ./ports/pyqt-webengine/next-pyqt-webengine.py \
        --replace "#!/usr/bin/env python3" "#!${next-pyqt.out}/bin/python"
  '';
  
  buildPhase = ''
    export HOME=$TMP
    make app-bundle
  '';

  installPhase = ''
    mkdir -p $out/Applications
    mv ./Next.app $out/Applications/Next.app
  '';
  
  meta = {
    platforms = stdenv.lib.platforms.darwin;
  };

  pathsToLink = [ "/Applications" ];
}
