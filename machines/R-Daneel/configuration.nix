# This is a machine-specific nix-darwin configuration file.

{ config, pkgs, ... }:

let
  nix-dir = "/Users/tviti/.config/nixpkgs";
  machine-dir = nix-dir + "/machines/R-Daneel";
  pkg-dir = nix-dir + "/pkgs";
  # yabai = pkgs.callPackage (pkg-dir + "/yabai") {
  #   inherit (pkgs.darwin.apple_sdk.frameworks) Carbon Cocoa ScriptingBridge;
  # };
in {
  imports = [
    # (nix-dir + "/services/yabai.nix")
    (nix-dir + "/configuration-common.nix")
    (nix-dir + "/nix-src/home-manager/nix-darwin")
  ];

  common-config.nix-dir = nix-dir;
  
  # If you move the repo, make sure to change these as well!
  environment.darwinConfig = "${machine-dir}/configuration.nix";
  nix = {
    nixPath = [
      "nixpkgs=${nix-dir}/nix-src/nixpkgs"
      "home-manager=${nix-dir}/nix-src/home-manager"
      "darwin=${nix-dir}/nix-src/nix-darwin"
      # "darwin-config=${machine-dir}/configuration.nix"
    ];
  };

  # Make sure nix is also aware of our relocated home-manager cfg
  # environment.variables = { HOME_MANAGER_CONFIG = "${machine-dir}/home.nix"; };

  users.users.tviti.name = "tviti";
  users.users.tviti.home = "/Users/tviti";
  home-manager.users.tviti = (import "${machine-dir}/home.nix");

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    # skhd
    # yabai
    # #xquartz # NOTE: You should run $ xquartz-install after installation
    # synergy
    # kitty
  ];

  services.nix-daemon.enable = true;

  # services.skhd.enable = true;
  # services.skhd.skhdConfig = builtins.readFile "${nix-dir}/config/skhdrc";
  # services.yabai = {
  #   enable = true;
  #   package = pkgs.yabai;
  # };

  # services.synergy = {
  #   inherit (import ./private/synergy.nix) client;
  # };
  
  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.bash.enable = true;
  programs.zsh.enable = true;
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # You should generally set this to the total number of logical cores in your system.
  # $ sysctl -n hw.ncpu
  nix.maxJobs = 1;
  nix.buildCores = 1;

  # system.defaults = {
  #   NSGlobalDomain = {
  #     # Enable subpixel font rendering on non-Apple LCDs
  #     # Reference: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
  #     AppleFontSmoothing = 1;
  #   };
  # };

  # Set your time zone.
  # time.timeZone = "Pacific/Honolulu";
}
