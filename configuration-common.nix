{ config, pkgs, stdenv, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    gnupg
    lsof
    pass
    pigz
    synergy
    vim
    wget
  ];

  # Needed for synergy
  nixpkgs.config.allowUnfree = true;

  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      dejavu_fonts
      fira-code
      hack-font
      inconsolata
      source-code-pro
    ];
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

}
