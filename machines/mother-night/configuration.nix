# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  hostname = "mother-night";
  nix-dir = "/home/tviti/.config/nixpkgs";
  machine-dir = "${nix-dir}/machines/${hostname}";
in {
  imports = [ 
    ./private/hardware-configuration.nix # Include the results of the hardware scan.
    (nix-dir + "/configuration-common.nix")
  ];

  common-config.nix-dir = nix-dir;

  # Make sure nix is also aware of our relocated home-manager cfg
  environment.variables = { HOME_MANAGER_CONFIG = "${machine-dir}/home.nix"; };

  nix = {
    nixPath = [
      # If you move the repo, make sure to change these as well!
      "nixpkgs=${nix-dir}/nix-src/nixpkgs"
      "home-manager=${nix-dir}/nix-src/home-manager"
      "nixos-config=${machine-dir}/configuration.nix"
    ];
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = hostname; # Define your hostname.
  networking.wireless.enable =
    true; # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp2s0.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "Pacific/Honolulu";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    displaylink
    firefox
    hfsprogs
    kitty
    pigz # Parallel version of gzip
    pinentry-qt
    xclip
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    pinentryFlavor = "qt";
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  
  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  services.xserver = {
    enable = true;

    layout = "us";
    xkbOptions = "ctrl:swapcaps"; # Swap ctrl/capslock keys

    # Enable touchpad support.
    libinput.enable = true;
    libinput.naturalScrolling = true;

    # Enable i3wm
    desktopManager.default = "none";
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [ dmenu i3status i3lock ];
      extraSessionCommands = ''
        # Multiple monitor configuration
        xrandr --output HDMI-1 --auto --above eDP-1
        xrandr --output DVI-I-2-1 --auto --right-of HDMI-1
      '';
    };

    # Enable insignia USB2HDMI dongle
    videoDrivers = [ "displaylink" ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tviti = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}

