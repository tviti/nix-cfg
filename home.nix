{ config, pkgs, ... }:

let home_directory = builtins.getEnv "HOME";
    my-python-packages = python-packages: with python-packages; [
      # Things for Nex
      # TODO: Move to a seperate package?
      pyqt5
      pyqtwebengine
    ];
    python-with-my-packages = pkgs.python3.withPackages my-python-packages;
in rec {
  home = {
    packages = [
      pkgs.git
      pkgs.aspell
      pkgs.aspellDicts.en
      pkgs.aspellDicts.en-computers
      pkgs.aspellDicts.en-science
      pkgs.pass

      python-with-my-packages
      pkgs.pandoc
      pkgs.haskellPackages.pandoc-citeproc
    ];

    sessionVariables = {
      ASPELL_CONF = "conf ${xdg.configHome}/aspell/config;";
    };
  };

  home.file.".bash_profile".source = ./.bash_profile;
  
  programs.git = {
    enable = true;
	  userName = "Taylor Viti";
	  userEmail = "tviti@hawaii.edu";
  };

  programs.gpg = {
    enable = true;
  };

  xdg = {
    enable = true;

    configHome = "${home_directory}/.config";

    configFile."aspell/config".text = ''
      home-dir ${home_directory}/Sync;
    '';
  };
  
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
