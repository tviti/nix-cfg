{}:

rec {
  version = "2019b";
  runPath = "$HOME/MATLAB/R${version}";
  targetPkgs = pkgs: with pkgs; [
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
}
