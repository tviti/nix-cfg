{ config, pkgs, stdenv, ... }:

let
  home-dir = builtins.getEnv "HOME";
  tmp-dir = "/tmp";
  pkg-dir = ./pkgs;
  config-dir = ./config;
  next = pkgs.callPackage (pkg-dir + "/next") { };
  nix-direnv = pkgs.callPackage (pkg-dir + "/nix-direnv/default.nix") { };
in rec {
  home = {
    packages = with pkgs;
      [
        aspell
        aspellDicts.en
        aspellDicts.en-computers
        aspellDicts.en-science
        # bibutils
        curl
        direnv
        gitFull
        gitAndTools.git-annex
        gitAndTools.git-annex-remote-rclone
        globus-cli
        ledger
        myEmacs
        # myR
        next
        nix-direnv
        nixfmt # for emacs nix-mode
        nodePackages.bash-language-server
        pandoc
        pv
        rclone
        subversion
        haskellPackages.pandoc-citeproc
        #pass
        wget
        vim
        texlab # LSP server for latex
        # lua53Packages.digestif # LSP server for latex
        # kitty-themes
      ] ++ myMappingTools;

    sessionVariables = {
      ALTERNATE_EDITOR = "${pkgs.vim}/bin/vi";
      EDITOR = "${pkgs.myEmacs}/bin/emacsclient";
    };
  };

  programs = {
    bash = {
      enable = true;
    };

    git = {
      enable = true;
      userName = "Taylor Viti";
      userEmail = "tviti@hawaii.edu";
      package = pkgs.gitFull;
    };

    ssh = {
      enable = true;

      controlMaster  = "auto";
      controlPath    = "${tmp-dir}/ssh-%u-%r@%h:%p";
      controlPersist = "1800";

      forwardAgent = true;
      serverAliveInterval = 60;
    };
  };

  home.file."/.aspell.conf".text = ''
      dict-dir ${home-dir}/.nix-profile/lib/aspell
      home-dir ${home-dir}/Sync
      personal ${home-dir}/Sync/.aspell.en.pws
  
      master en_US
      extra-dicts en_US-science.rws
      add-extra-dicts en-computers.rws
  '';


  xdg = {
    enable = true;

    # Configuration files
    configHome = "${home-dir}/.config";

    configFile."next".source = config-dir + "/next-cfg";
    configFile."i3".source = config-dir + "/i3";
    configFile."i3status".source = config-dir + "/i3status";
    configFile."direnv/direnvrc".text = ''
      source ${nix-direnv}/share/nix-direnv/direnvrc
    '';

    # configFile."kitty/kitty.conf".text = ''
    #   # Load a theme
    #   include ${kitty-themes}/share/kitty-themes/gruvbox_light.conf
    # '';
  };

  home.file.".chktexrc".source = config-dir + "/chktexrc";
  
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
