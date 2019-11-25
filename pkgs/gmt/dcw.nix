{ pkgs, stdenv, fetchurl, ... }:

stdenv.mkDerivation rec {
  name = "dcw-gmt";
  version = "1.1.4";
  src = fetchurl {
    url = "ftp://ftp.soest.hawaii.edu/gmt/dcw-gmt-${version}.tar.gz";
    sha256 = "8d47402abcd7f54a0f711365cd022e4eaea7da324edac83611ca035ea443aad3";
  };

  installPhase = ''
    mkdir -p $out/share/dcw-gmt
    cp -rv ./* $out/share/dcw-gmt
  '';

  meta = with stdenv; {
    homepage = "https://www.soest.hawaii.edu/pwessel/dcw/";
    description = ''
      DCW-GMT is an enhancement to the original 1:1,000,000 scale vector basemap
      of the world.
    '';
    longDescription = ''
      DCW-GMT is an enhancement to the original 1:1,000,000 scale vector basemap
      of the world, available from the Princeton University Digital Map and
      Geospatial Information Center. It contains more state boundaries (the
      largest 8 countries are now represented) than the original data
      source. Information about DCW can be found on Wikipedia
      (https://en.wikipedia.org/wiki/Digital_Chart_of_the_World). This data is
      for use by GMT, the Generic Mapping Tools.  '';
    license = lib.licenses.lgpl3Plus;
  };

}
