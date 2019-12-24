{ config, pkgs, ... }:

let
  nix-dir = "/Users/taylor/.config/nixpkgs";
  home_directory = builtins.getEnv "HOME";
  config-dir = ../../config;
in rec {
  imports = [
    (nix-dir + "/home-common.nix")
  ];
  
  home.packages = with pkgs;
    [
      bibutils
      pass
    ];

  programs = {
    bash = {
      enable = true;
      profileExtra = ''
        export PATH=$PATH:/Applications/MATLAB_R2016a.app/bin/
        source ${home_directory}/.nix-profile/etc/profile.d/nix.sh
      '';
    };

    gpg.enable = true;
  };

  xdg.configFile."skhd/skhdrc".source = config-dir + "/skhdrc";
  xdg.configFile."yabai/yabairc".source = config-dir + "/yabairc";
}
