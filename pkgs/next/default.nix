/* A derivation for building Next browser with the PyQtWebEngine frontend. This was
   originally written to install on a Darwin system, and I have had problems with
   getting it working on a CentOS 7 machine (the next-pyqt derivation fails to
   install PyQt5 and PyQtWebEngine).

   Since the nixpkgs libfixposix derivation does not support Darwin, I have
   packaged it myself (with the .nix file based on the brew recipe). It would
   probably be better to actually pass this dependency as an argument, but since
   we rely on this specific derivation, I just call it directly from
   here. Ideally, we would also let nix handle the quicklisp dependencies, but
   those nixpkgs also don't support Darwin (ASDF is the first to throw an
   error), hence this package uses quicklisp directly.  */

{ pkgs, stdenv, fetchurl, sbcl, ... }:

let
  libfixposix = if stdenv.isDarwin then
    pkgs.callPackage ../libfixposix { }
  else
    pkgs.libfixposix;
  next-pyqt = pkgs.callPackage ./next-pyqt.nix { };
in stdenv.mkDerivation rec {
  name = "next";
  version = "1899e526b32ac766b6242e5ed6358ec36df66f5b";

  src = fetchurl {
    url = "https://github.com/tviti/next/archive/${version}.tar.gz";
    sha256 = "0dwbn61jnjw8im44w037j6kclh5xkk9xh9b0s6sf53a5p3a07ixw";
  };

  patches = [ ./Makefile-fixtypo.patch ];

  # Stripping destroys the generated SBCL image
  dontStrip = true;

  nativeBuildInputs = [ pkgs.sbcl libfixposix ];
  buildInputs = with pkgs; [ next-pyqt curl cacert dbus pass ];

  # Set the port to use the next-pyqt python env
  configurePhase = ''
    substituteInPlace ./ports/pyqt-webengine/next-pyqt-webengine.py \
        --replace "#!/usr/bin/env python3" "#!${next-pyqt.out}/bin/python"
  '';

  # Quicklisp will want to create a few hidden-/dot-dirs in $HOME (which will
  # fail due to nix' use of homeless-shelter), so we instead point it to $out
  buildPhase = if stdenv.isDarwin then ''
    export HOME=$out/Applications/Next.app/Contents/MacOS/
    mkdir -p $out/Applications/Next.app/Contents/MacOS/
    make app-bundle
  '' else ''
    make next
  '';

  installPhase = if stdenv.isDarwin then ''
    mkdir -p $out/bin
    cp -rv ./Next.app $out/Applications/
    rm -rf ./Next.app
    ln -s $out/Applications/Next.app/Contents/MacOS/next $out/bin/next
  '' else ''
    install -D -m0755 next $out/bin/next
  '';

  meta = with stdenv; { platforms = [ "x86_64-linux" "x86_64-darwin" ]; };

}
