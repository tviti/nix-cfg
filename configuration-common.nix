{ lib, config, pkgs, stdenv, ... }:

let
  cfg = config.common-config;
in {
  options.common-config = {
    nix-dir = lib.mkOption {
      type = lib.types.path;
    };
  };

  config = {
    nixpkgs = {
      # Taken from John Wiegley's nix-config repo
      overlays =
        let path = cfg.nix-dir + "/overlays"; in with builtins;
              map (n: import (path + ("/" + n)))
                (filter (n: match ".*\\.nix" n != null ||
                            pathExists (path + ("/" + n + "/default.nix")))
                  (attrNames (readDir path)));
    };

    environment.systemPackages = with pkgs; [
      gitFull
      gnupg
      lsof
      pigz
      python3
      synergy
      vim
      wget
    ];

    # Needed for synergy
    nixpkgs.config.allowUnfree = true;

    fonts = {
      fontDir.enable = true;
      fonts = with pkgs; [
        iosevka
        dejavu_fonts
        fira-code
        hack-font
        inconsolata
        source-code-pro
      ];
    };

    programs.gnupg.agent = {
      enable = true;
    };
  };
}
