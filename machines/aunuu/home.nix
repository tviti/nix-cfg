{ config, pkgs, stdenv, ... }:

let
  nix-dir = "/home/tviti/.config/nixpkgs";
  pkg-dir = nix-dir + "/pkgs";
  kitty-themes = pkgs.callPackage (pkg-dir + "/kitty-themes") { };
  matlabAndTools = pkgs.callPackage (pkg-dir + "/matlab/default.nix") { };
  plotdigitizer = pkgs.callPackage (pkg-dir + "/plotdigitizer/default.nix") { };
  globus-connect-personal = pkgs.callPackage (pkg-dir + "/globus-connect") { };
  globus-cli = pkgs.callPackage (pkg-dir + "/globus-cli") { };
  idv = pkgs.callPackage (pkg-dir + "/idv/default.nix") {
    jogl = pkgs.javaPackages.jogl_2_3_2;
  };

  zoom-i3wm = pkgs.writeScriptBin "zoom-i3wm" ''
    #!${pkgs.bash}/bin/bash

    ${pkgs.xcompmgr}/bin/xcompmgr -c -l0 -t0 -r0 -o.00 &
    export XCOMPMGR_PID=$!
    function finish {
      echo "Killing xcompmgr..."
      kill $XCOMPMGR_PID
    }

    ${pkgs.zoom-us}/share/zoom-us/ZoomLauncher

    trap finish EXIT
  '';

  nyxt = nyxt-dir: pkgs.writeScriptBin "nyxt" ''
    #!/bin/sh
    # Wrapper for an impure build of nyxt. Assumes that a valid shell.nix file
    # exists in nyxt-dir, and that the nyxt binary has already been built
    # imperatively.

    nix-shell ${nyxt-dir}/shell.nix --run "${nyxt-dir}/nyxt $@"
  '';

in rec {
  imports = [
    (nix-dir + "/home-common.nix")
  ];

  home.packages = [
    # idv
    matlabAndTools.matlab
    matlabAndTools.mlint
    # plotdigitizer
    kitty-themes
    # globus-cli
    globus-connect-personal
    (nyxt "$HOME/Source/next")
  ] ++ (with pkgs; [
    qgis
    skypeforlinux
    spotify
    libreoffice
    mu
    ncview
    netcdf # for ncdump utility
    zoom-i3wm
  ]);

  xdg.configFile."kitty/kitty.conf".text = ''
    # Load a theme
    include ${kitty-themes}/share/kitty-themes/Afterglow.conf

    enable_audio_bell no

    font_size 12.0
  '';

  home.file."/.ncviewrc".text = ''
    -1 "STRINGLIST_SAVE_FILE_VERSION" INT 1
    0 "NCVIEW_STATE_FILE_VERSION" INT 1
    1 "CMAP_blu_red" INT 1
    2 "CMAP_detail" INT 1
    3 "CMAP_ssec" INT 1
    4 "CMAP_bright" INT 1
    5 "CMAP_banded" INT 1
    6 "CMAP_rainbow" INT 1
    7 "CMAP_jaisnb" INT 1
    8 "CMAP_jaisnc" INT 1
    9 "CMAP_jaisnd" INT 1
    10 "CMAP_3gauss" INT 1 
    11 "CMAP_manga" INT 1
    12 "CMAP_jet" INT 1
    13 "CMAP_wheel" INT 1
    14 "CMAP_3saw" INT 1
    15 "CMAP_bw" INT 1
    16 "CMAP_default" INT 1
    17 "CMAP_extrema" INT 1
    18 "CMAP_helix" INT 1
    19 "CMAP_helix2" INT 1
    20 "CMAP_hotres" INT 1
  '';
  
  services.syncthing.enable = true;
  services.caffeine.enable = true;

  #
  # Email cfg
  #
  accounts.email.maildirBasePath = import ./private/maildirBasePath.nix { };
  accounts.email.accounts = import ./private/email.nix { inherit pkgs; };

  programs.msmtp.enable = true;
  programs.mbsync.enable = true;
  services.imapnotify.enable = true; # Turn on IMAP IDLE (i.e. push)
  services.mbsync.enable = true;  # Turn on auto-syncing service
  services.mbsync.postExec = ''
    ${pkgs.myEmacs}/bin/emacsclient -e "(mu4e-update-index)"
  '';

  #
  # Gnupg cfg
  #
  home.file."/.gnupg/gpg.conf".source = ./private/gpg.conf;
}

