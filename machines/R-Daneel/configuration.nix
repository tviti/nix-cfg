# This is a machine-specific nix-darwin configuration file.

{ config, pkgs, ... }:

let
  yabai = pkgs.callPackage ../pkgs/yabai {
    inherit (pkgs.darwin.apple_sdk.frameworks) Carbon Cocoa ScriptingBridge;
  };
in {
  imports = [ ../services/yabai.nix ];

  nix = {
    nixPath = [
      # If you move the repo, make sure to change these as well!
      "nixpkgs=$HOME/.config/nixpkgs/nix-src/nixpkgs"
      "home-manager=$HOME/.config/nixpkgs/nix-src/home-manager"
      "darwin=$HOME/.config/nixpkgs/nix-src/nix-darwin"
    ];
  };

  nixpkgs = {
    # Taken from John Wiegley's nix-config repo
    overlays =
      let path = ../overlays; in with builtins;
      map (n: import (path + ("/" + n)))
          (filter (n: match ".*\\.nix" n != null ||
                      pathExists (path + ("/" + n + "/default.nix")))
                  (attrNames (readDir path)));
  };

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

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    skhd
    yabai
    xquartz # NOTE: You should run $ xquartz-install after installation
    synergy
  ];

  services.skhd.enable = true;

  services.yabai = {
    enable = true;
    package = yabai;
  };

  services.synergy = {
    inherit (import ./private/synergy.nix) client;
  };
  
  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  environment.darwinConfig = "$HOME/.config/nixpkgs/machines/R-Daneel.nix";

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.bash.enable = true;
  # programs.zsh.enable = true;
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # You should generally set this to the total number of logical cores in your system.
  # $ sysctl -n hw.ncpu
  nix.maxJobs = 1;
  nix.buildCores = 1;

  system.defaults = {
    NSGlobalDomain = {
      # Enable subpixel font rendering on non-Apple LCDs
      # Reference: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
      AppleFontSmoothing = 1;
    };
  };
}