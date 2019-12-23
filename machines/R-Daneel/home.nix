{ config, pkgs, ... }:

let
  home_directory = builtins.getEnv "HOME";
  config-dir = ../../config;
in rec {
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
