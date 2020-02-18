{ config, pkgs, stdenv, ... }:

let
  nix-dir = "/home/tviti/.config/nixpkgs";
  pkg-dir = nix-dir + "/pkgs";
  kitty-themes = pkgs.callPackage (pkg-dir + "/kitty-themes") { };
in rec {
  imports = [
    (nix-dir + "/home-common.nix")
  ];

  home.packages = [
    kitty-themes
    pkgs.spotify
  ];

  xdg.configFile."kitty/kitty.conf".text = ''
    # Load a theme
    include ${kitty-themes}/share/kitty-themes/gruvbox_light.conf
  '';

  services.syncthing.enable = true;
}
