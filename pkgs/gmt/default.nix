{ pkgs, stdenv, fetchurl, cmake, Accelerate, CoreGraphics, CoreVideo
, ghostscript, fftwSinglePrec, netcdf, pcre, gdal, blas, lapack }:

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

  nativeBuildInputs = [ cmake ];

  buildInputs = (with pkgs; [ curl gdal netcdf pcre dcw gshhg ])
    ++ (if stdenv.isDarwin then [
      Accelerate
      CoreGraphics
      CoreVideo
    ] else [
      fftwSinglePrec
      blas
      lapack
    ]);

  propagatedBuildInputs = [ ghostscript ];

  cmakeFlags = [
    "-DGMT_DOCDIR=$out/share/doc/gmt"
    "-DGMT_MANDIR=$out/share/man"
    "-DGSHHG_ROOT=${gshhg.out}/gshhg-gmt"
    "-DDCW_ROOT=${dcw.out}/dcw-gmt"
    "-DCOPY_DCW:BOOL=FALSE"
    "-DGDAL_ROOT=${gdal.out}"
    "-DNETCDF_ROOT=${netcdf.out}"
    "-DPCRE_ROOT=${pcre.out}"
    "-DGMT_INSTALL_TRADITIONAL_FOLDERNAMES:BOOL=FALSE"
    "-DLICENSE_RESTRICTED=LGPL" # "GPL" and "no" also valid
  ] ++ (with stdenv;
    lib.optional isDarwin [
      "-DFFTW3_ROOT=${fftwSinglePrec.dev}"
      "-DLAPACK_LIBRARY=${lapack}/lib/liblapack.so"
      "-DBLAS_LIBRARY=${blas}/lib/libblas.so"
    ]);

  meta = with stdenv.lib; {
    homepage = "https://www.generic-mapping-tools.org";
    description = "Tools for manipulating geographic and cartesian data sets.";
    longDescription = ''
      GMT is an open-source collection of command-line tools for manipulating
      geographic and Cartesian data sets (including filtering, trend fitting,
      gridding, projecting, etc.) and producing high-quality illustrations
      ranging from simple x–y plots via contour maps to artificially illuminated
      surfaces and 3D perspective views. It supports many map projections and
      transformations and includes supporting data such as coastlines, rivers,
      and political boundaries and optionally country polygons.
    '';
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    license = licenses.lgpl3Plus;
    # maintainers = with maintainers; [ tviti ];
  };
}
