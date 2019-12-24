{ config, pkgs, stdenv, ... }:

let
  nix-dir = "/Users/taylor/.config/nixpkgs";
in rec {
  nixpkgs = {
    # Taken from John Wiegley's nix-config repo
    overlays =
      let path = nix-dir + "/overlays"; in with builtins;
      map (n: import (path + ("/" + n)))
          (filter (n: match ".*\\.nix" n != null ||
                      pathExists (path + ("/" + n + "/default.nix")))
                  (attrNames (readDir path)));
  };

  environment.systemPackages = with pkgs; [
    git
    gnupg
    lsof
    pass
    pigz
    synergy
    vim
    wget
  ];

  # Needed for synergy
  nixpkgs.config.allowUnfree = true;

  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      dejavu_fonts
      fira-code
      hack-font
      inconsolata
      source-code-pro
    ];
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

}
