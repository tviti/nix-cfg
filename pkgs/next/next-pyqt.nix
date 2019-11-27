{ pkgs, stdenv, next, ... }:

stdenv.mkDerivation {
  name = "next-pyqt";
  inherit (next) src version;

  buildInputs = [ pkgs.python3 ];
  propagatedBuildInputs = [ pkgs.python3Packages.virtualenvwrapper ];

  phases = [ "installPhase" ];

  installPhase = ''
    virtualenv $out
    source $out/bin/activate
    pip install pyqt5 PyQtWebEngine
  '';

  pathsToLink = [ ];

  meta = with stdenv; {
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}

