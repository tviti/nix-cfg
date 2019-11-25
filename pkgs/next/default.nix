{ pkgs, ... }:

with pkgs;
let
  libfixposix = pkgs.callPackage ../libfixposix { };
in stdenv.mkDerivation rec {
  name = "next-pyqt";
  version = "9d65598a0911a09e3befcad65444763a51527913";

  src = fetchurl {
    url = "https://github.com/tviti/next/archive/${version}.tar.gz";
    sha256 = "0ba7i7yn6ya7qdc768z4z23x2zyq78w67pgs6abav2jyxp83qy2n";
  };

  builder = "${bash}/bin/bash";
  args = [ ./builder.sh ];

  # Stripping destroys the generated SBCL image
  dontStrip = true;

  propagatedBuildInputs = with python3Packages; [
    virtualenvwrapper
  ];

  nativeBuildInputs =
    [ sbcl makeWrapper libfixposix ];

  buildInputs =  [ python3  curl cacert dbus gcc gzip pass ];

  meta = {
    platforms = stdenv.lib.platforms.darwin;
  };
}