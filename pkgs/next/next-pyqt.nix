{ pkgs, stdenv, next, ... }:

stdenv.mkDerivation {
  name = "next-pyqt";
  inherit (next) src version;

  buildInputs = [ pkgs.python3 ];
  propagatedBuildInputs = with pkgs.python3Packages; [ pyqt5 pyqtwebengine ];

  phases = [ ];

  pathsToLink = [ ];

  meta = with stdenv; { platforms = [ "x86_64-linux" "x86_64-darwin" ]; };
}

