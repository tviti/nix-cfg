{ stdenv, python3, python3Packages, next }:

stdenv.mkDerivation {
  name = "next-pyqt";
  inherit (next) src version;

  buildInputs = [ python3 ];
  propagatedBuildInputs = [ python3Packages.virtualenvwrapper ];

  phases = [ "installPhase" ];

  installPhase = ''
    virtualenv $out
    source $out/bin/activate
    pip install pyqt5 PyQtWebEngine # This fails on CentOS for some reason
  '';

  pathsToLink = [ ];

  meta = with stdenv; { platforms = [ "x86_64-darwin" ]; };
}

