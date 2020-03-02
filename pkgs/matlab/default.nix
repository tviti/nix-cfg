{ stdenv, buildFHSUserEnv }:

let
  version = "2019b";
  runPath = "$HOME/MATLAB/R${version}";
in buildFHSUserEnv {
  name = "matlab";

  targetPkgs = pkgs:
    (with pkgs; [
      udev
      coreutils
      alsaLib
      dpkg
      gcc6
      zlib
      freetype
      glib
      zlib
      fontconfig
      openssl
      which
      ncurses
      jdk11
      pam
      dbus_glib
      dbus
      pango
      gtk2-x11
      atk
      gdk_pixbuf
      cairo
    ]) ++ (with pkgs.xorg; [
      libX11
      libXcursor
      libXrandr
      libXext
      libSM
      libICE
      libXdamage
      libXrender
      libXfixes
      libXcomposite
      libxcb
      libXi
      libXScrnSaver
      libXtst
      libXt
      libXxf86vm
    ]);

  # runScript = "bash";
  runScript = "${runPath}/bin/matlab";
}
