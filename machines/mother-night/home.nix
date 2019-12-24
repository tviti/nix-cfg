{ config, pkgs, stdenv, ... }:

let
  pkg-dir = ../../pkgs;
  kitty-themes = pkgs.callPackage (pkg-dir + "/kitty-themes") { };
in rec {
  imports = [
    ../../home-common.nix
  ];

  home.packages = [
    kitty-themes
    pkgs.spotify
    pkgs.gitAndTools.git-annex
  ];

  xdg.configFile."kitty/kitty.conf".text = ''
    # Load a theme
    include ${kitty-themes}/share/kitty-themes/gruvbox_light.conf
  '';
}
