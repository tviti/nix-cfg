{ config, pkgs, ... }:

let home_directory = builtins.getEnv "HOME";
    next = import ./mypkgs/next/default.nix;
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

  # home.file.".bash_profile".source = ./.bash_profile;

  programs.bash = {
    enable = true;

    initExtra = ''
      export PATH=$PATH:/Applications/MATLAB_R2016a.app/bin/
    '';

    profileExtra = ''
      source ~/.nix-profile/etc/profile.d/nix.sh
    '';
  };
  
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
      dict-dir ${home_directory}/.nix-profile/lib/aspell
      home-dir ${home_directory}/Sync
      personal /Users/taylor/Sync/.aspell.en.pws

      master en_US
      extra-dicts en_US-science.rws
      add-extra-dicts en-computers.rws
    '';
  };
  
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
