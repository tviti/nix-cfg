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
      #bibutils
      #pass
      #kitty
      #mu
    ];

  programs = {
    bash = {
      enable = true;
      profileExtra = ''
        #source ${home_directory}/.nix-profile/etc/profile.d/nix.sh
      '';
    };

    zsh.enable = true;
    zsh.profileExtra = ''
        export HOMEBREW_PREFIX="/opt/homebrew";
        export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
        export HOMEBREW_REPOSITORY="/opt/homebrew";
        export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
        export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
        export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";

        # >>> conda initialize >>>
        # !! Contents within this block are managed by 'conda init' !!
        __conda_setup="$('/opt/homebrew/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
        if [ $? -eq 0 ]; then
            eval "$__conda_setup"
        else
            if [ -f "/opt/homebrew/anaconda3/etc/profile.d/conda.sh" ]; then
                . "/opt/homebrew/anaconda3/etc/profile.d/conda.sh"
            else
                export PATH="/opt/homebrew/anaconda3/bin:$PATH"
            fi
        fi
        unset __conda_setup
        # <<< conda initialize <<<
    '';

    #gpg.enable = true;
  };

  # Make sure shells can find MATLAB
  home.sessionPath = [ "/Applications/MATLAB_R2022a.app/bin" ];
    

  #xdg.configFile."skhd/skhdrc".source = config-dir + "/skhdrc";
  #xdg.configFile."yabai/yabairc".source = config-dir + "/yabairc";
}
