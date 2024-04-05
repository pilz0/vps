
### Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, modules, ... }:

{
  imports = [
    # Include the results of the hardware scan.
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
  console.keyMap = "de";
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
      users.users.marie.isNormalUser = true;
      users.users.marie.description = "marie";
      users.users.marie.extraGroups = [ "networkmanager" "wheel" ];
    
  #Services
  #zsh
    networking.networkmanager.enable = true;
  #Mullvad VPN
    services.mullvad-vpn.enable = true;
  #Flakes
  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
     };
  # Maii keyy :3 
  users.users.marie.openssh.authorizedKeys.keys = ["sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIBTGgUYUsIAtcbZBqk5Mq0LH2T5KGFjdjAgNIwUf+/LBAAAABHNzaDo= pilz@framewok"];
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  #Docker
  virtualisation.docker.enable = true;
  #All my Programms :3
  environment.systemPackages = with pkgs; [
    htop
    busybox
    prometheus
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
    docker-compose
    vlc
    alacritty
    cmatrix
    btop
    wget
    gtop
    freerdp
    killall
    picocom
    dnsmasq
    spotifyd
    pipes
    ddclient
    ];
    #an openssh banner, is shown everytime you try to connect
    services.openssh.banner = "
      ***************************************************************************
                                  NOTICE TO USERS
      This is a Federal computer system and is the property of the United
      States Government. It is for authorized use only. Users (authorized or
      unauthorized) have no explicit or implicit expectation of privacy.
      Any or all uses of this system and all files on this system may be
      intercepted, monitored, recorded, copied, audited, inspected, and disclosed to
      authorized site, Department of Energy, and law enforcement personnel,
      as well as authorized officials of other agencies, both domestic and foreign.
      By using this system, the user consents to such interception, monitoring,
      recording, copying, auditing, inspection, and disclosure at the discretion of
      authorized site or Department of Energy personnel.
      Unauthorized or improper use of this system may result in administrative
      disciplinary action and civil and criminal penalties. By continuing to use
      this system you indicate your awareness of and consent to these terms and
      conditions of use. LOG OFF IMMEDIATELY if you do not agree to the conditions
      stated in this warning.
      *****************************************************************************";
# spotifyd is a service for streaming spotify to this device
services.spotifyd.enable = true;
  programs.zsh.enable = true;
    programs.zsh.ohMyZsh.enable = true;
    programs.zsh.ohMyZsh.theme = "crunch";
    programs.zsh.autosuggestions.enable = true;
    programs.zsh.shellAliases = { backup = "restic -r rclone:onedrive:/backup/server1 backup --verbose /home";};
    programs.zsh.shellAliases = { update = "sudo nix flake update /home/marie/server";};
    programs.zsh.shellAliases = { rebuild = "sudo nixos-rebuild --flake /home/marie/server switch";};
    users.defaultUserShell = pkgs.zsh;
  #git  
    programs.git.config.user.name = "pilz0";
    programs.git.config.user.email = "marie0@riseup.net";
# Autoupdate 
system.autoUpgrade = {
  enable = true;
  flake = "github:pilz0/server";
  flags = [
    "--update-input"
    "nixpkgs"
    "-L" # print build logs
  ];
  dates = "02:00";
  randomizedDelaySec = "45min";
};
  environment.sessionVariables.NIXPKGS_ALLOW_UNFREE="1"; 
# Openssh
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  programs.ssh.startAgent = true;
    # dyndns
systemd.timers."dyndns" = {
  wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "5m";
      Unit = "dyndns";
    };
};

systemd.services."dyndns" = {
  script = ''bash /home/marie/dyndns/DDNS-Cloudflare-Bash/update-cloudflare-dns.sh
  '';
  serviceConfig = {
    Type = "oneshot";
    User = "marie";
  };
};
nix.optimise.automatic = true;
nix.optimise.dates = [ "03:45" ]; # Optional; allows customizing optimisation schedule

systemd.timers."gitpull" = {
  wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "60m";
      OnUnitActiveSec = "60m";
      Unit = "gitpull";
    };
};

systemd.services. "gitpull" = {
  script = ''git pull /home/marie/server
  '';
  timerConfig = {
      OnCalendar = "daily";
      Persistent = true; 
  };
};

systemd.timers."rebuild" = {
  wantedBy = [ "timers.target" ];
    timerConfig = {
  timerConfig = {
      OnCalendar = "daily";
      Persistent = true; 
  };
};

systemd.services. "gitpull" = {
  script = ''rebuild
  '';
  serviceConfig = {
    Type = "oneshot";
    User = "marie";
  };
};

      # Open ports in the firewall.
   networking.firewall.allowedTCPPorts = [ 1100 11000 81 8080 443 80 22 3000 8443 1337 ];
   networking.firewall.allowedUDPPorts = [ 1100 11000 81 8080 443 80 22 3000 8443 1337 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
# NixOS Version
  system.stateVersion = "23.11"; # Did you read the comment?
}
  ## github copilot wrote this
#  I hope you can help me. 
#  I’m not sure if this is the issue, but I think you need to use  users.users.marie.openssh.authorizedKeys.keys  instead of  users.users.marie.openssh.authorizedKeys . 
#  I tried it, but it didn’t work. 
#  I think the problem is that the authorizedKeys.keys is not a list of strings, but a list of objects with a key and a value. 
#  I think the problem is that the authorizedKeys.keys is not a list of strings, but a list of objects with a key and a value. 
#  That’s not correct. The  authorizedKeys.keys  attribute is a list of strings. 
#  I’m not sure what the problem is, but I can confirm that the  authorizedKeys.keys  attribute is a list of strings. 
#  I’m sorry, I was wrong.