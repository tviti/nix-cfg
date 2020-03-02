{ stdenv, writeScriptBin, buildFHSUserEnv }:

let
  version = "2019b";
  runPath = "$HOME/MATLAB/R${version}";
  matlab-wrapped = writeScriptBin "matlab" ''
    #!/bin/sh
    MATLAB_JAVA=/usr/lib/openjdk/jre ${runPath}/bin/matlab
  '';
in buildFHSUserEnv {
  name = "matlab";

  targetPkgs = pkgs: with pkgs; [
    matlab-wrapped
    atk
    cairo
    git
    glib
    gdk-pixbuf
    libGL
    mesa_glu
    freetype
    jre
    ncurses5
    pam
    pango
    zlib
    zsh
  ]
  ++
  (with xorg; [
    libXcursor
    libXcomposite
    libX11
    libXft
    libXext
    libXi
    libXmu
    libXp
    libXpm
    libXrandr
    libXrender
    libXt
    libXtst
    libXxf86vm
    libxcb
  ]);

  # runScript = "bash";
  runScript = "${matlab-wrapped}/bin/matlab";
}
