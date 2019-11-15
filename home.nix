{ config, pkgs, ... }:

let home_directory = builtins.getEnv "HOME";
    next = import ./next/default.nix;
in rec {
  home = {
    packages = [
      pkgs.git
      pkgs.aspell
      pkgs.aspellDicts.en
      pkgs.aspellDicts.en-computers
      pkgs.aspellDicts.en-science
      pkgs.pass
      pkgs.curl
      
      pkgs.pandoc
      pkgs.haskellPackages.pandoc-citeproc

      # pkgs.dbus
      # pkgs.dbus_daemon
      # pkgs.dbus_libs
      pkgs.qt5.qtbase
      next
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
