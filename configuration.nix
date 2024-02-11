### Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  #Hostname
  networking.hostName = "serva";
  #Self doxx UwU
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "de";
    xkbVariant = "";
  };

  console.keyMap = "de";
  services.printing.enable = true;
  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  #my user account
  users.users.marie = {
    isNormalUser = true;
    description = "marie";
    extraGroups = [ "networkmanager" "wheel" ];
     packages = with pkgs; [
    ];
  };
# Maii keyy :3 
users.users.marie.openssh.authorizedKeys.keys = ["sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIBTGgUYUsIAtcbZBqk5Mq0LH2T5KGFjdjAgNIwUf+/LBAAAABHNzaDo= pilz@framewok"];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  #Services
  #zsh
  programs.zsh.enable = true;
  programs.zsh.ohMyZsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  #Network manager
  networking.networkmanager.enable = true; 
  #Mullvad VPN
  services.mullvad-vpn.enable = true;
  #Docker
  virtualisation.docker.enable = true;
  #All my Programms :3
  environment.systemPackages = with pkgs; [
    htop
    onionshare
    unzip
    vim
    fastfetch
    neofetch
    zsh
    nmap
    hyfetch
    go
    lshw
    traceroute
    speedtest-cli
    rustc
    pciutils
    docker
    git
    veracrypt
    metasploit
    ecryptfs
    gnumake
    wireshark-qt
    superTuxKart
    cargo
    gcc
    vlc
    alacritty
    cmatrix
    btop
    gtop
    freerdp
    killall
    spotifyd
    pipes
  ];

services.openssh.banner = "Hinweis   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .   .  7]
    Saemtliche Aktionen auf diesem System werden protokolliert und koennen
                         gerichtlich verwendet werden.
                Unerlaubter Zugriff wird strafrechtlich verfolgt.";


services.spotifyd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    # enableSSHSupport = true;
   };

  # List services that you want to enable:

 #  Enable the OpenSSH daemon.
   services.openssh.enable = true;
#   Disable PasswordAuthentication 
   services.openssh.settings.PasswordAuthentication = false;

  # Open ports in the firewall.
   networking.firewall.allowedTCPPorts = [ 8080,443,80,22,3000,8443 ];
   networking.firewall.allowedUDPPorts = [ 8080,443,80,22,3000,8443 ];
  # Or disable the firewall altogether.
#   networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
