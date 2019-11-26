{ config, pkgs, ... }:

let home_directory = builtins.getEnv "HOME";
    next = pkgs.callPackage ./pkgs/next { };
    gmt = pkgs.callPackage ./pkgs/gmt {
      inherit (pkgs.darwin.apple_sdk.frameworks) Accelerate CoreGraphics CoreVideo;
    };
in rec {
  home = {
    packages = with pkgs; [
      aspell aspellDicts.en aspellDicts.en-computers aspellDicts.en-science
      bibutils
      curl
      git
      ghostscript
      gmt
      my-emacs
      next
      nixfmt # for emacs nix-mode
      pandoc haskellPackages.pandoc-citeproc
      pass
      R-with-my-packages
      wget
      vim
    ];

    sessionVariables = {
      ASPELL_CONF = "conf ${xdg.configHome}/aspell/config;";
    };
  };

  # home.file.".bash_profile".source = ./.bash_profile;

  programs.bash = {
    enable = true;

    profileExtra = ''
      export PATH=$PATH:/Applications/MATLAB_R2016a.app/bin/
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

    configFile."skhd/skhdrc".source = ./config/skhdrc;
    configFile."yabai/yabairc".source = ./config/yabairc;
    configFile."aspell/config".text = ''
      dict-dir ${home_directory}/.nix-profile/lib/aspell
      home-dir ${home_directory}/Sync
      personal /Users/taylor/Sync/.aspell.en.pws

      master en_US
      extra-dicts en_US-science.rws
      add-extra-dicts en-computers.rws
    '';
  };

  home.file.".chktexrc".source = ./config/chktexrc;
  
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
