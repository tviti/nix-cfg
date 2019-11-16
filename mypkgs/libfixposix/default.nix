# This file is basically a transliteration of the brew recipe for libfixposix.
# For some reason, the one in nixpkgs doesn't support darwin, so I rolled my own.

with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "libfixposix";
  version = "0.4.3";

  src = fetchurl {
    url = "https://github.com/sionescu/libfixposix/archive/v${version}.tar.gz";
    sha256 = "78fe8bcebf496520ac29b5b65049f5ec1977c6bd956640bdc6d1da6ea04d8504";
  };

  configurePhase = ''
    autoreconf -fvi
    ./configure --disable-dependency-tracking \
                --disable-silent-rules \
                --prefix=$out
  '';

  buildInputs = [ autoconf automake libtool pkg-config git getconf ];

  installPhase = ''
    make install
  '';
}
