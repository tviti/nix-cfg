with import <nixpkgs> {};
stdenv.mkDerivation rec {
  version = "0.4.3";
  name = "libfixposix";
  src = fetchurl {
    url = "https://github.com/sionescu/libfixposix/archive/v${version}.tar.gz";
    sha256 = "78fe8bcebf496520ac29b5b65049f5ec1977c6bd956640bdc6d1da6ea04d8504";
  };

  buildPhase = ''
    tar -xvzf ${src}
    cd ./libfixposix-${version}
    
    autoreconf -fvi
    ./configure --disable-dependency-tracking \
                --disable-silent-rules \
                --prefix=$out
    make 
  '';

  installPhase = ''
    make install
  '';

  buildInputs = [ autoconf automake libtool pkg-config git getconf ];
}
