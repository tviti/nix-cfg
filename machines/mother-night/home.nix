{ config, pkgs, ... }:

let
  home-dir = builtins.getEnv "HOME";
  pkg-dir = ../../pkgs;
  config-dir = ../../config;
  next = pkgs.callPackage (pkg-dir + "/next") { };
  texlab = pkgs.callPackage (pkg-dir + "/texlab") { };
  kitty-themes = pkgs.callPackage (pkg-dir + "/kitty-themes") { };
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
        git
        gitAndTools.git-annex
        myEmacs
        myR
        next
        nixfmt # for emacs nix-mode
        pandoc
        pv
        spotify
        haskellPackages.pandoc-citeproc
        #pass
        wget
        vim
        # texlab # LSP server for latex
        # lua53Packages.digestif # LSP server for latex
        kitty-themes
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
        # export PATH=$PATH:/Applications/MATLAB_R2016a.app/bin/
        # source ${home-dir}/.nix-profile/etc/profile.d/nix.sh
      '';
    };

    git = {
      enable = true;
      userName = "Taylor Viti";
      userEmail = "tviti@hawaii.edu";
    };

    # gpg.enable = true;
  };

  xdg = {
    enable = true;

    # Configuration files
    configHome = "${home-dir}/.config";

    configFile."next".source = config-dir + "/next-cfg";
    configFile."i3".source = config-dir + "/i3";

    configFile."aspell/config".text = ''
      dict-dir ${home-dir}/.nix-profile/lib/aspell
      home-dir ${home-dir}/Sync
      personal ${home-dir}/Sync/.aspell.en.pws

      master en_US
      extra-dicts en_US-science.rws
      add-extra-dicts en-computers.rws
    '';

    configFile."kitty/kitty.conf".text = ''
      # Load a theme
      include ${kitty-themes}/share/kitty-themes/gruvbox_light.conf
    '';
  };

  home.file.".chktexrc".source = config-dir + "/chktexrc";

  services.syncthing.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

}
