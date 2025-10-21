{ pkgs, config, ... }@inputs:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.supportedFilesystems = [ "ntfs" "zfs" ];
  boot.zfs.extraPools = [ "tank" ];
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.kernelParams = [ "zfs.zfs_arc_max=17179869184" ]; # 16GB ARC limit
  networking.hostId = "8425e349"; # Required for ZFS

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # the following needs to be executed manually on the system
  # zfs set mountpoint=/mnt/storage tank
  # zfs set canmount=on tank
  # zfs set mountpoint=/mnt/photos tank/photos
  # zfs set canmount=on tank/photos

  services.zfs = {
    autoScrub.enable = true;
    autoScrub.interval = "monthly";
    trim.enable = true;
  };

  services.sanoid = {
    enable = true;
    datasets = {
      "tank/photos" = {
        frequently = 15; # 15 snapshots taken every 15 minutes
        hourly = 24; # 24 hourly snapshots
        daily = 30; # 30 daily snapshots
        monthly = 12; # 12 monthly snapshots
      };
    };
  };

  # system.activationScripts.createZfsPools = pkgs.lib.stringAfter [ "var" ] ''
  #   # Create main tank pool if it doesn't exist
  #   if ! ${pkgs.zfs}/bin/zpool list tank >/dev/null 2>&1; then
  #     echo "Creating ZFS pool 'tank'..."
  #     ${pkgs.zfs}/bin/zpool create -o ashift=12 -m /mnt/storage tank \
  #       /dev/disk/by-id/wwn-0x5000c500f6824101 \
  #       /dev/disk/by-id/wwn-0x50014ee003d2bb01 \
  #       /dev/disk/by-id/wwn-0x50014ee2b20b046c
  #
  #     # Create photos dataset
  #     ${pkgs.zfs}/bin/zfs create tank/photos
  #     ${pkgs.zfs}/bin/zfs set quota=1T tank/photos
  #     ${pkgs.zfs}/bin/zfs set mountpoint=/mnt/photos tank/photos
  #   fi
  #
  #   # Create backup pool if it doesn't exist and USB is connected
  #   if ! ${pkgs.zfs}/bin/zpool list backup >/dev/null 2>&1; then
  #     if [ -e /dev/disk/by-id/wwn-0x50014ee20f1d6642 ]; then
  #       echo "Creating ZFS pool 'backup' on USB..."
  #       ${pkgs.zfs}/bin/zpool create -o ashift=12 -m /mnt/backup backup \
  #         /dev/disk/by-id/wwn-0x50014ee20f1d6642
  #     fi
  #   fi
  # '';

  xdg.autostart.enable = true;
  networking.hostName = "media"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  networking.firewall.interfaces.enp42s0.allowedTCPPorts = [ 80 443 8080 8123 ];
  networking.firewall.interfaces.enp42s0.allowedUDPPorts = [ 8080 ];

  # Set your time zone.
  time.timeZone = "Africa/Johannesburg";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
  };

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    videoDrivers = [ "nvidia" ];

    desktopManager = {
      xterm.enable = false;
      gnome = {
        enable = true;
      };
    };
    displayManager = {
      defaultSession = "gnome";
      lightdm = {
        enable = true;
      };
      autoLogin = {
        user = "william";
        enable = true;
      };
    };
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # set in Home manager
  users = {
    defaultUserShell = pkgs.zsh;
    mutableUsers = false;
    groups.storage = { };
    users.root.extraGroups = [ "storage" ];
    users.sonarr.extraGroups = [ "storage" ];
    users.radarr.extraGroups = [ "storage" ];
    users.immich.extraGroups = [ "storage" ];
    users.syncthing.extraGroups = [ "storage" ];
    users.caddy.extraGroups = [ "storage" ];
    users.william = {
      isNormalUser = true;
      description = "William Bezuidenhout";
      extraGroups = [ "storage" "networkmanager" "wheel" "docker" ];
      hashedPassword = "$6$Rz1GnmAfbEsmPZ52$Ze2ue2JtgVxwT5x1AA7k.KL0rY4.HTmHn8yn3IjjwAbflFqf3hUELMA/W/nADGoHZa0nxuFKBcIALl4kOCcEP/";
      openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6iuO9BMUxIaDlnUbRjPAi4d44nvEL4mSbTqUWAw53xEC9tRKGi7HxXBGVZzT6riDBdaI5Kibxj4fWMt3SMnSbxSjFOleS7iNRjjKyEGUnnpekVCHtye2tNDaRvnKwK4/ZG8Kd/t/aKYyWmPZJEVfWUM3iiFgBHh/3ml0Zgb/Y0QCxP7FdIyCeMY3f8AW6wGVfNH3BBvRlpQt+rNwYmp/kmsrxalgUGpzHOlpKQbzh+0Ox5I73RF+nK7VBJA6OAan6n7zyfy40y/LwQieckqbi2Jogd438G8iqnQYkIXFCMV8IFCQ4wjAnDvdfOBysdKlxwS+1ZNHv0UGHT4jbRw0N william.bezuidenhout+ssh@gmail.com" ];
    };
  };

  systemd.tmpfiles.rules = [
    "d /mnt/storage                       2775 root storage -"
    "d /mnt/storage/downloads             2775 root storage -"
    "d /mnt/storage/downloads/nzb         2775 root storage -"
    "d /mnt/storage/downloads/torrents    2775 root storage -"
    "d /mnt/storage/series                2775 root storage -"
    "d /mnt/storage/movies                2775 root storage -"
    "d /mnt/photos                        2775 root storage -"
  ];
  hardware.xpadneo.enable = true;
  hardware.enableAllFirmware = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      LE = {
        MinConnectionInterval = 7;
        MaxConnectionInterval = 8;
        ConnectionLatency = 0;
      };
    };
  };
  services.blueman.enable = true;


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
    with pkgs; [
      aspell
      aspellDicts.en
      aspellDicts.en-computers
      aspellDicts.en-science
      autossh
      bash
      btrfs-progs
      curl
      fd
      nil
      firefox
      chromium
      flameshot
      gcc
      git
      gnumake
      go
      htop
      jq
      kitty
      lua
      man-pages
      man-pages-posix
      mkpasswd
      inputs.unstable.neovim
      nodejs_20
      nmap
      nss
      pavucontrol
      pipewire
      python3
      shairplay
      spotify
      tmux
      unrar
      unzip
      vlc
      wget
      xclip
    ];

  programs.zsh.enable = true;
  programs.steam = {
    enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    settings.trusted-users = [ "root" "william" ];
    gc = {
      dates = "weekly";
      options = "--delete-older-than 60d";
    };
    optimise.automatic = true;
  };

  environment.shells = with pkgs; [ zsh ];

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    nerd-fonts.hack
    nerd-fonts.jetbrains-mono
  ];

  services.immich = {
    enable = true;
    port = 33333;
    package = inputs.unstable.immich;
    mediaLocation = "/mnt/photos";
    openFirewall = true;
    settings.server.externalDomain = "https://photos.burmudar.dev";
  };

  services.caddy =
    let
      allowRanges = [
        "100.64.0.0/10" # tailscale
        "169.0.0.0/15" # afrihost
        "192.168.0.0/16"
        "172.16.0.0/12"
        "10.0.0.0/8"
        "127.0.0.1/8"
      ];
      genHandleFragment = { host, proxy, ... }@vars:
        let
          hasPath = if builtins.hasAttr "path" vars then true else false;
          suffix =
            if hasPath then
              "-${pkgs.lib.removePrefix "/" vars.path}"
            else
              "";
          sub = (builtins.elemAt (builtins.split "\\." host) 0);
          matcher = "${sub}${suffix}";
        in
        ''
          ${if hasPath then "redir ${vars.path} ${vars.path}/" else "" }
          @${matcher} {
            host ${host}
          }
          ${if hasPath then
          ''
          handle_path ${vars.path}* {
            reverse_proxy ${proxy} {
              header_up Host {upstream_hostport}
            }
          }
          '' else ''
          reverse_proxy @${matcher} ${proxy} {
            header_up Host {upstream_hostport}
          }
          ''}
        '';
      preambleFragment = host: ''
        @denied {
          not host ${host}
          not remote_ip ${toString allowRanges}
        }

        abort @denied

      '';
      cfgGen = host: tls: ''
        ${if tls == "" then "" else"tls ${tls}"}
        ${preambleFragment host}
        ${genHandleFragment { host = "sync.${host}"; proxy = "http://localhost:10200"; path = "/seedbox"; }}
        ${genHandleFragment { host = "sync.${host}"; proxy = "http://localhost:10100"; path = "/local"; }}
        ${genHandleFragment { host = "nzb.${host}"; proxy = "http://seedbox.raptor-emperor.ts.net:10100"; }}
        ${genHandleFragment { host = "jellyfin.${host}"; proxy = "http://localhost:8096"; }}
        ${genHandleFragment { host = "jacket.${host}"; proxy = "http://localhost:9117"; }}
        ${genHandleFragment { host = "sonar.${host}"; proxy = "http://localhost:8989"; }}
        ${genHandleFragment { host = "radar.${host}"; proxy = "http://localhost:7878"; }}
        ${genHandleFragment { host = "photos.${host}"; proxy = "http://localhost:33333"; }}
        handle /ok {
          respond "Ok this works"
        }
      '';
      token = (import ./token.nix).value;
    in
    {
      enable = true;
      email = "william.bezuidenhout@gmail.com";
      package = pkgs.caddy.withPlugins {
        plugins = [ "github.com/caddy-dns/cloudflare@v0.2.1" ];
        hash = "sha256-2D7dnG50CwtCho+U+iHmSj2w14zllQXPjmTHr6lJZ/A=";
      };
      # instead of readFile we should read the token from age or something like that
      logFormat = ''
        output stdout
      '';
      virtualHosts = {
        "media.burmudar.dev" = {
          extraConfig = ''
            tls { dns cloudflare ${token} }
            ${preambleFragment "media.burmudar.dev"}
            reverse_proxy http://localhost:8096
          '';
        };
        "photos.burmudar.dev" = {
          extraConfig = ''
            tls { dns cloudflare ${token} }
            ${preambleFragment "photos.burmudar.dev" }
            reverse_proxy http://localhost:33333
          '';
        };
        "media.raptor-emperor.ts.net" = {
          extraConfig = ''
            tls {
              dns cloudflare ${token}
              get_certificate tailscale
            }
            ${preambleFragment "media.raptor-emperor.ts.net"}
            reverse_proxy http://localhost:8096
          '';
        };
        "files.burmudar.dev" = {
          extraConfig = ''
            tls { dns cloudflare ${token} }
            ${preambleFragment "files.burmudar.dev" }
            basic_auth {
              christina $2a$14$/3G/orCpr1ZGSxkZL.Snb.kngyDlg28sPvi8lU5g2Rb/HMdYFD8Ke
              william $2a$14$MdrKAPy9E2Af7oVlt5Ehc.0lj.Wy6IiRUagHZz1q/HnOgx4BEAsQe
              sourcegraph $2a$14$K15WAUpbvDSN0L83Nxx/NOmj1HNGFBsOSwpjhQPBHxGtmKV287Bgm
            }
            file_server {
            root /mnt/storage/
            browse
            }
          '';
        };
        "*.media.internal" = {
          extraConfig = cfgGen "media.internal" "internal";
        };
      };
    };

  # because we're using a custom caddy package
  systemd.services.caddy.serviceConfig.AmbientCapabilities = "CAP_NET_BIND_SERVICE";
  # there is a bug where wailt online service always times out
  # see https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = false;

  services.avahi = {
    enable = true;
    nssmdns = true;
    publish = {
      addresses = true;
      domain = true;
      enable = true;
    };
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };
  services.tailscale = {
    enable = true;
    permitCertUid = "caddy";
    package = inputs.unstable.tailscale;
    extraSetFlags = [
      "--advertise-exit-node"
      "--advertise-routes=192.168.1.0/24"
    ];
  };

  services.sonarr = {
    enable = true;
    package = inputs.unstable.sonarr;
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  services.jackett = {
    enable = true;
  };

  services.radarr = {
    enable = true;
  };

  services.cloudflare-dns-ip = {
    enable = true;
    zone = "burmudar.dev";
    record = "media,files,photos";
  };

  services.syncthing = {
    enable = true;
    overrideFolders = true;
    guiAddress = "localhost:10100";
    settings = {
      options = {
        listenAddresses = [
          "localhost:22000"
        ];
        minHomeDiskFree = {
          unit = "%";
          value = 1;
        };
      };
      devices = {
        "seedbox" = {
          addresses = [
            "tcp://localhost:22001"
          ];
          id = "SEK5G5M-PY7VIIS-QE25HGK-Y3ELPKP-CENVTWN-52KDYKK-PCI7X3B-UN5KHAO";
        };
      };
      folders = {
        "NZB" = {
          path = "/mnt/storage/downloads/nzb";
          id = "nzb";
          devices = [ "seedbox" ];
          type = "sendreceive";
        };
        "Torrents" = {
          path = "/mnt/storage/downloads/torrents";
          id = "torrents";
          devices = [ "seedbox" ];
          type = "sendreceive";
        };
      };
    };

  };

  # 22000: syncthing listen address on this machine
  # 22001: listenAddress on the seedbox
  # 10200: GUI of syncthing on the seedbox
  services.autossh.sessions = [
    {
      extraArguments = "-N -R 22002:localhost:22000 -L 22001:localhost:22001 -L 10200:0.0.0.0:10200 seedbox";
      monitoringPort = 23000;
      name = "seedbox";
      user = "william";
    }
  ];

  # Backup photos to USB nightly at 12pm
  systemd.services.backup-photos = {
    description = "Backup photos to USB drive";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.zfs}/bin/zfs send -I tank/photos@daily | ${pkgs.zfs}/bin/zfs receive -F backup/photos";
      User = "root";
    };
    preStart = ''
      # Create snapshot
      ${pkgs.zfs}/bin/zfs snapshot tank/photos@daily

      # Import backup pool if not imported
      if ! ${pkgs.zfs}/bin/zpool list backup >/dev/null 2>&1; then
        ${pkgs.zfs}/bin/zpool import backup
      fi
    '';
  };

  systemd.timers.backup-photos = {
    description = "Timer for daily photo backup";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "12:00";
      Persistent = true;
    };
  };


  # Enable docker daemon to start
  virtualisation.docker.enable = true;
  #virtualisation.docker.storageDriver = "btrfs";


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
  # Stop Gnome 3 from suspending
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # Needed otherwise we get some binaries complaining that they can't find glibc
  system.activationScripts.ldso = pkgs.lib.stringAfter [ "usrbinenv" ] ''
    mkdir -m 0755 -p /lib64
    ln -sfn ${pkgs.glibc.out}/lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2.tmp
    mv -f /lib64/ld-linux-x86-64.so.2.tmp /lib64/ld-linux-x86-64.so.2 # atomically replace
  '';
}
