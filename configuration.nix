
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
    curl
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
  dates = "hourly";
  allowReboot = false; #
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
  path = [ "curl" "busybox" "toybox" "bash" ];
  script = '' "
#!/usr/bin/env bash
###  Create .update-cloudflare-dns.log file of the last run for debug
parent_path="$(dirname "${BASH_SOURCE[0]}")"
FILE=/home/marie/dnydns/update-cloudflare-dns.log
if ! [ -x "$FILE" ]; then
  touch "$FILE"
fi

LOG_FILE=/home/marie/dnydns/update-cloudflare-dns.log'

### Write last run of STDOUT & STDERR as log file and prints to screen
exec > >(tee $LOG_FILE) 2>&1
echo "==> $(date "+%Y-%m-%d %H:%M:%S")"

### Validate if config-file exists

if [[ -z "$1" ]]; then
  if ! source /home/marie/dnydns/update-cloudflare-dns.conf; then
    echo 'Error! Missing configuration file update-cloudflare-dns.conf or invalid syntax!'
    exit 0
  fi
else
  if ! source $/home/marie/dnydns/"$1"; then
    echo 'Error! Missing configuration file '$1' or invalid syntax!'
    exit 0
  fi
fi

### Check validity of "ttl" parameter
if [ "${ttl}" -lt 120 ] || [ "${ttl}" -gt 7200 ] && [ "${ttl}" -ne 1 ]; then
  echo "Error! ttl out of range (120-7200) or not set to 1"
  exit
fi

### Check validity of "proxied" parameter
if [ "${proxied}" != "false" ] && [ "${proxied}" != "true" ]; then
  echo 'Error! Incorrect "proxied" parameter, choose "true" or "false"'
  exit 0
fi

### Check validity of "what_ip" parameter
if [ "${what_ip}" != "external" ] && [ "${what_ip}" != "internal" ]; then
  echo 'Error! Incorrect "what_ip" parameter, choose "external" or "internal"'
  exit 0
fi

### Check if set to internal ip and proxy
if [ "${what_ip}" == "internal" ] && [ "${proxied}" == "true" ]; then
  echo 'Error! Internal IP cannot be proxied'
  exit 0
fi

### Valid IPv4 Regex
REIP='^((25[0-5]|(2[0-4]|1[0-9]|[1-9]|)[0-9])\.){3}(25[0-5]|(2[0-4]|1[0-9]|[1-9]|)[0-9])$'

### Get external ip from https://checkip.amazonaws.com
if [ "${what_ip}" == "external" ]; then
  ip=$(curl -4 -s -X GET https://checkip.amazonaws.com --max-time 10)
  if [ -z "$ip" ]; then
    echo "Error! Can't get external ip from https://checkip.amazonaws.com"
    exit 0
  fi
  if ! [[ "$ip" =~ $REIP ]]; then
    echo "Error! IP Address returned was invalid!"
    exit 0
  fi
  echo "==> External IP is: $ip"
fi

### Get Internal ip from primary interface
if [ "${what_ip}" == "internal" ]; then
  ### Check if "IP" command is present, get the ip from interface
  if which ip >/dev/null; then
    ### "ip route get" (linux)
    interface=$(ip route get 1.1.1.1 | awk '/dev/ { print $5 }')
    ip=$(ip -o -4 addr show ${interface} scope global | awk '{print $4;}' | cut -d/ -f 1)
  ### If no "ip" command use "ifconfig" instead, to get the ip from interface
  else
    ### "route get" (macOS, Freebsd)
    interface=$(route get 1.1.1.1 | awk '/interface:/ { print $2 }')
    ip=$(ifconfig ${interface} | grep 'inet ' | awk '{print $2}')
  fi
  if [ -z "$ip" ]; then
    echo "Error! Can't read ip from ${interface}"
    exit 0
  fi
  echo "==> Internal ${interface} IP is: $ip"
fi

### Build coma separated array fron dns_record parameter to update multiple A records
IFS=',' read -d '' -ra dns_records <<<"$dns_record,"
unset 'dns_records[${#dns_records[@]}-1]'
declare dns_records

for record in "${dns_records[@]}"; do
  ### Get IP address of DNS record from 1.1.1.1 DNS server when proxied is "false"
  if [ "${proxied}" == "false" ]; then
    ### Check if "nslookup" command is present
    if which nslookup >/dev/null; then
      dns_record_ip=$(nslookup ${record} 1.1.1.1 | awk '/Address/ { print $2 }' | sed -n '2p')
    else
      ### if no "nslookup" command use "host" command
      dns_record_ip=$(host -t A ${record} 1.1.1.1 | awk '/has address/ { print $4 }' | sed -n '1p')
    fi

    if [ -z "$dns_record_ip" ]; then
      echo "Error! Can't resolve the ${record} via 1.1.1.1 DNS server"
      exit 0
    fi
    is_proxed="${proxied}"
  fi

  ### Get the dns record id and current proxy status from Cloudflare API when proxied is "true"
  if [ "${proxied}" == "true" ]; then
    dns_record_info=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zoneid/dns_records?type=A&name=$record" \
      -H "Authorization: Bearer $cloudflare_zone_api_token" \
      -H "Content-Type: application/json")
    if [[ ${dns_record_info} == *"\"success\":false"* ]]; then
      echo ${dns_record_info}
      echo "Error! Can't get dns record info from Cloudflare API"
      exit 0
    fi
    is_proxed=$(echo ${dns_record_info} | grep -o '"proxied":[^,]*' | grep -o '[^:]*$')
    dns_record_ip=$(echo ${dns_record_info} | grep -o '"content":"[^"]*' | cut -d'"' -f 4)
  fi

  ### Check if ip or proxy have changed
  if [ ${dns_record_ip} == ${ip} ] && [ ${is_proxed} == ${proxied} ]; then
    echo "==> DNS record IP of ${record} is ${dns_record_ip}", no changes needed.
    continue
  fi

  echo "==> DNS record of ${record} is: ${dns_record_ip}. Trying to update..."

  ### Get the dns record information from Cloudflare API
  cloudflare_record_info=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zoneid/dns_records?type=A&name=$record" \
    -H "Authorization: Bearer $cloudflare_zone_api_token" \
    -H "Content-Type: application/json")
  if [[ ${cloudflare_record_info} == *"\"success\":false"* ]]; then
    echo ${cloudflare_record_info}
    echo "Error! Can't get ${record} record information from Cloudflare API"
    exit 0
  fi

  ### Get the dns record id from response
  cloudflare_dns_record_id=$(echo ${cloudflare_record_info} | grep -o '"id":"[^"]*' | cut -d'"' -f4)

  ### Push new dns record information to Cloudflare API
  update_dns_record=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zoneid/dns_records/$cloudflare_dns_record_id" \
    -H "Authorization: Bearer $cloudflare_zone_api_token" \
    -H "Content-Type: application/json" \
    --data "{\"type\":\"A\",\"name\":\"$record\",\"content\":\"$ip\",\"ttl\":$ttl,\"proxied\":$proxied}")
  if [[ ${update_dns_record} == *"\"success\":false"* ]]; then
    echo ${update_dns_record}
    echo "Error! Update failed"
    exit 0
  fi

  echo "==> Success!"
  echo "==> $record DNS Record updated to: $ip, ttl: $ttl, proxied: $proxied"

  ### Telegram notification
  if [ ${notify_me_telegram} == "no" ]; then
    exit 0
  fi

  if [ ${notify_me_telegram} == "yes" ]; then
    telegram_notification=$(
      curl -s -X GET "https://api.telegram.org/bot${telegram_bot_API_Token}/sendMessage?chat_id=${telegram_chat_id}" --data-urlencode "text=${record} DNS record updated to: ${ip}"
    )
    if [[ ${telegram_notification=} == *"\"ok\":false"* ]]; then
      echo ${telegram_notification=}
      echo "Error! Telegram notification failed"
      exit 0
    fi
  fi
done
" '';
  serviceConfig = {
    ReadWritePaths = [ "/home/marie/dnydns" ];
    Type = "oneshot";
    User = "marie";
  };
};
nix.optimise.automatic = true;
nix.optimise.dates = [ "03:45" ]; # Optional; allows customizing optimisation schedule

systemd.timers."gitpull" = {
  wantedBy = [ "timers.target" ];
  timerConfig = {
      OnCalendar = "daily";
      Persistent = true; 
  };
};

systemd.services. "gitpull" = {
  script = ''git pull /home/marie/server
  '';
    serviceConfig = {
    Type = "oneshot";
    User = "marie";
  };
  };

systemd.timers."rebuild" = {
  wantedBy = [ "timers.target" ];
  timerConfig = {
      OnCalendar = "daily";
      Persistent = true; 
  };
};

systemd.services. "rebuild" = {
  script = ''nixos-rebuild --flake /home/marie/server switch
  '';
  serviceConfig = {
    Type = "oneshot";
    User = "root";
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