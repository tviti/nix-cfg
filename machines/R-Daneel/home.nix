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
        export PATH=$PATH:/Applications/MATLAB_R2019b.app/bin/
        source ${home_directory}/.nix-profile/etc/profile.d/nix.sh

        # added by Anaconda2 5.0.0 installer
        # export PATH="/Users/taylor/anaconda2/bin:$PATH"  # commented out by conda initialize

        # >>> conda initialize >>>
        # !! Contents within this block are managed by 'conda init' !!
        # __conda_setup="$('/Users/taylor/anaconda2/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
        # if [ $? -eq 0 ]; then
        #     eval "$__conda_setup"
        # else
        #     if [ -f "/Users/taylor/anaconda2/etc/profile.d/conda.sh" ]; then
        #         . "/Users/taylor/anaconda2/etc/profile.d/conda.sh"
        #     else
        #         export PATH="/Users/taylor/anaconda2/bin:$PATH"
        #     fi
        # fi
        # unset __conda_setup
        # <<< conda initialize <<<
      '';
    };

    gpg.enable = true;
  };

  #xdg.configFile."skhd/skhdrc".source = config-dir + "/skhdrc";
  xdg.configFile."yabai/yabairc".source = config-dir + "/yabairc";
}
