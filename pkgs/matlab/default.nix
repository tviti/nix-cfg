{ stdenv, buildFHSUserEnv }:

let
  version = "2019b";
  runPath = "$HOME/MATLAB/R${version}";
in buildFHSUserEnv {
  name = "matlab";

  targetPkgs = pkgs: with pkgs; [
    glib
    libGL
    jre
    mesa_glu
    ncurses
    pam
    zlib
  ]
  ++
  (with xorg; [
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
  runScript = "${runPath}/bin/matlab";
}
