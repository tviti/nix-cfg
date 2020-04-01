{ config, pkgs, stdenv, ... }:

let
  nix-dir = "/home/tviti/.config/nixpkgs";
  pkg-dir = nix-dir + "/pkgs";
  kitty-themes = pkgs.callPackage (pkg-dir + "/kitty-themes") { };
  matlabAndTools = pkgs.callPackage (pkg-dir + "/matlab/default.nix") { };
in rec {
  imports = [
    (nix-dir + "/home-common.nix")
  ];

  home.packages = [
    matlabAndTools.matlab
    matlabAndTools.mlint
    kitty-themes
  ] ++ (with pkgs; [
    skypeforlinux
    spotify
    mu
  ]);

  xdg.configFile."kitty/kitty.conf".text = ''
    # Load a theme
    include ${kitty-themes}/share/kitty-themes/gruvbox_light.conf
  '';

  services.syncthing.enable = true;

  #
  # Email cfg
  #
  accounts.email.accounts = import ./private/email.nix { inherit pkgs; };

  programs.msmtp.enable = true;
  programs.mbsync.enable = true;
  services.mbsync.enable = true;  # Turn on auto-syncing service

  #
  # Gnupg cfg
  #
  home.file."/.gnupg/gpg.conf".source = ./private/gpg.conf;
}
