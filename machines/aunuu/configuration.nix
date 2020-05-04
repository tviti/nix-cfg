# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  hostname = "aunuu";
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

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;

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
    borgbackup
    displaylink
    firefox
    hfsprogs
    kitty
    man-db
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

  # Enable ssh-agent. Keys will still have to be manually added using ssh-add.
  programs.ssh.startAgent = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ epson-escpr ];

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

    # Enable touchpad support.
    libinput.enable = true;
    libinput.naturalScrolling = true;

    # Enable i3wm
    displayManager.defaultSession = "none+i3";
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [ dmenu i3status i3lock ];
      extraSessionCommands = ''
        # Multiple monitor configuration.
        xrandr --output DVI-I-1-1 --auto --right-of DP-3 # SAMSUNG
      '';
    };

    videoDrivers = [
      "nvidia"
      "displaylink" # Insignia USB2HDMI dongle
    ];
  };

  # services.borgbackup.jobs = {
  #   inherit (import ./private/borgbackup.nix) homeBackup;
  # };

  services.logind = {
    extraConfig = ''
      IdleAction=lock
      IdleActionSec=900
    '';
  };

  # Yubikey packages and settings
  services.pcscd.enable = true;
  services.udev.packages = [ pkgs.yubikey-personalization ];
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tviti = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}

