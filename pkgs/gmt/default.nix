{ pkgs, stdenv, fetchurl, cmake, Accelerate, CoreGraphics, CoreVideo, ... }:

let
  dcw = pkgs.callPackage ./dcw.nix { };
  gshhg = pkgs.callPackage ./gshhg.nix { };
in stdenv.mkDerivation rec {
  pname = "gmt";
  version = "6.0.0";
  src = fetchurl {
    url = "ftp://ftp.soest.hawaii.edu/gmt/gmt-${version}-src.tar.xz";
    sha256 = "8b91af18775a90968cdf369b659c289ded5b6cb2719c8c58294499ba2799b650";
  };

  nativeBuildInputs = if stdenv.isDarwin then [
    cmake
    # NOTE: These are specific to darwin
    Accelerate
    CoreGraphics
    CoreVideo
  ] else
    [ cmake ];

  buildInputs = with pkgs; [ curl fftw gdal netcdf pcre dcw gshhg ];

  configurePhase = ''
    mkdir build ; cd build
    cmake -DCMAKE_INSTALL_PREFIX=$prefix \
          -DGMT_DOCDIR=$out/share/doc/gmt \
          -DGMT_MANDIR=$out/share/man \
          -DGSHHG_ROOT=${gshhg.out}/gshhg-gmt \
          -DDCW_ROOT=${dcw.out}/dcw-gmt \
          -DCOPY_DCW:BOOL=FALSE \
          -DFFTW3_ROOT=${pkgs.fftw.out} \
          -DGDAL_ROOT=${pkgs.gdal.out} \
          -DNETCDF_ROOT=${pkgs.netcdf.out} \
          -DPCRE_ROOT=${pkgs.pcre.out} \
          -DGMT_INSTALL_TRADITIONAL_FOLDERNAMES:BOOL=FALSE \
          -DLICENSE_RESTRICTED:BOOL=FALSE \
          ..
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.generic-mapping-tools.org";
    description = ''
      The Generic Mapping Toolbox: Tools for manipulating and plotting
      geographic and Cartesian data.
    '';
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
