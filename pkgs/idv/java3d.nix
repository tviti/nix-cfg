{ fetchurl, p7zip, stdenv }:

stdenv.mkDerivation rec {
  pname = "java3d";
  version = "1.6.2";

  src = fetchurl {
    url = "https://jogamp.org/deployment/java3d/${version}/jogamp-java3d.7z";
    sha256 = "1xmzmxxqbgmwh131dghm49izacsy4dn4fh5kn5yz40vhisbxfykg";
  };

  buildInputs = [ p7zip ];
  
  phases = [ "unpackPhase" "installPhase" ];

  unpackPhase = ''
    ${p7zip}/bin/7z x $src
  '';
  
  installPhase = ''
    mkdir -p $out/share/java
    cp ./*.jar $out/share/java/
  '';
}
