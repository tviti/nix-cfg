{ config, pkgs, ... }:

let
  home_directory = builtins.getEnv "HOME";
  next = pkgs.callPackage ./pkgs/next { };
in rec {
  home = {
    packages = with pkgs; [
      aspell
      aspellDicts.en
      aspellDicts.en-computers
      aspellDicts.en-science
      bibutils
      curl
      git
      myEmacs
      myR
      next
      nixfmt # for emacs nix-mode
      pandoc
      haskellPackages.pandoc-citeproc
      pass
      wget
      vim
    ] ++ myMappingTools;

    sessionVariables = {
      ASPELL_CONF = "conf ${xdg.configHome}/aspell/config;";
      ALTERNATE_EDITOR = "${pkgs.vim}/bin/vi";
      EDITOR = "${pkgs.myEmacs}/bin/emacsclient";
    };
  };

  programs = {
    bash = {
      enable = true;
      profileExtra = ''
        export PATH=$PATH:/Applications/MATLAB_R2016a.app/bin/
        source ${home_directory}/.nix-profile/etc/profile.d/nix.sh
      '';
    };

    git = {
      enable = true;
      userName = "Taylor Viti";
      userEmail = "tviti@hawaii.edu";
    };

    gpg.enable = true;
  };
  
  xdg = {
    enable = true;
    configHome = "${home_directory}/.config";

    configFile."next".source = ./config/next-cfg;
    configFile."skhd/skhdrc".source = ./config/skhdrc;
    configFile."yabai/yabairc".source = ./config/yabairc;
    configFile."aspell/config".text = ''
      dict-dir ${home_directory}/.nix-profile/lib/aspell
      home-dir ${home_directory}/Sync
      personal ${home_directory}/Sync/.aspell.en.pws

      master en_US
      extra-dicts en_US-science.rws
      add-extra-dicts en-computers.rws
    '';
  };

  home.file.".chktexrc".source = ./config/chktexrc;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
