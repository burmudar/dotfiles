{ pkgs, config, ... }:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.supportedFilesystems = [ "ntfs" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems = {
    "/mnt/storage1" = {
      device = "/dev/disk/by-partuuid/e0d8361c-edc1-4310-b7b0-6ab79b801d34";
      fsType = "ntfs";
    };
    "/mnt/storage2" = {
      device = "/dev/disk/by-partuuid/bcdbd6f3-a33f-41f4-a713-d6333752acef";
      fsType = "ntfs";
    };
  };

  networking.hostName = "media-pc"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # defining a static route fails on first boot for some reasonn
  # networking.nameservers = [
  #   "192.168.1.1"
  # ];
  # networking.interfaces.enp42s0 = {
  #   wakeOnLan.enable = true;
  #   ipv4 = {
  #     addresses = [
  #       {
  #         address = "192.168.1.101";
  #         prefixLength = 32;
  #       }
  #     ];
  #     routes = [ { address = "192.168.1.1"; prefixLength = 32; via = "192.168.1.1"; } ];
  #   };
  # };

  networking.firewall.interfaces.enp42s0.allowedTCPPorts = [ 80 443 ];

  # Set your time zone.
  time.timeZone = "Africa/Johannesburg";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";
  console = {
    font = "Lat2-Terminus16";
  };

  hardware.opengl.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.nvidia.nvidiaSettings = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    videoDrivers = [ "nvidia" ];

    desktopManager = {
      xterm.enable = false;
      plasma5.enable = true;
    };
    displayManager = {
      autoLogin = {
        user = "william";
        enable = true;
      };
      sddm.enable = true;
    };
  };

  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    elisa
    gwenview
    okular
    oxygen
    khelpcenter
    konsole
    plasma-browser-integration
    print-manager
  ];

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
    users.william = {
      isNormalUser = true;
      description = "William Bezuidenhout";
      extraGroups = [ "networkmanager" "wheel" "docker" ];
      hashedPassword = "$6$Rz1GnmAfbEsmPZ52$Ze2ue2JtgVxwT5x1AA7k.KL0rY4.HTmHn8yn3IjjwAbflFqf3hUELMA/W/nADGoHZa0nxuFKBcIALl4kOCcEP/";
      openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6iuO9BMUxIaDlnUbRjPAi4d44nvEL4mSbTqUWAw53xEC9tRKGi7HxXBGVZzT6riDBdaI5Kibxj4fWMt3SMnSbxSjFOleS7iNRjjKyEGUnnpekVCHtye2tNDaRvnKwK4/ZG8Kd/t/aKYyWmPZJEVfWUM3iiFgBHh/3ml0Zgb/Y0QCxP7FdIyCeMY3f8AW6wGVfNH3BBvRlpQt+rNwYmp/kmsrxalgUGpzHOlpKQbzh+0Ox5I73RF+nK7VBJA6OAan6n7zyfy40y/LwQieckqbi2Jogd438G8iqnQYkIXFCMV8IFCQ4wjAnDvdfOBysdKlxwS+1ZNHv0UGHT4jbRw0N william.bezuidenhout+ssh@gmail.com" ];
    };
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    autossh
    bash
    btrfs-progs
    cloudflare-caddy
    curl
    fd
    firefox
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
    neovim
    nmap
    nss
    pavucontrol
    pipewire
    python3
    spotify
    tmux
    unzip
    vlc
    wget
    xclip
  ];

  programs.zsh.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    settings.trusted-users = [ "root" "william" ];
    gc.automatic = true;
    optimise.automatic = true;
  };

  environment.shells = with pkgs; [ zsh ];

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "Hack" "JetBrainsMono" ]; })
  ];


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
      genHandleFragment = { directive, path, address }: ''
        handle ${directive} {
          uri strip_prefix /${path}
          reverse_proxy ${address} {
            header_up Host {upstream_hostport}
          }
        }
      '';
      cfgGen = { host, tls }: ''
        tls ${tls}
        @host {
          host ${host}
        }
        @sync-seedbox {
          @host
          path /sync/seedbox/*
        }
        @sync-local {
          @host
          path /sync/local/*
        }

        @nzb {
          @host
          path /nzb/*
        }

        @sonar {
          @host
          path /sonar/*
        }

        @radar {
          @host
          path /radar/*
        }

        @jacket {
          @host
          path /jacket/*
        }

        @jellyfin {
          @host
          path /jellyfin/*
        }

        @denied {
          not @host
          not remote_ip ${toString allowRanges}
        }

        abort @denied

        ${genHandleFragment "@sync-seedbox" "/sync/seedbox" ":10200"}
        ${genHandleFragment "@sync-local" "/sync/local" ":10200"}
        ${genHandleFragment "@nzb" "nzb" "http://seedbox.raptor-emperor.ts.net:10100"}
        ${genHandleFragment "@jellyfin" "jellyfin" ":8096"}
        ${genHandleFragment "@jacket" "jacket" ":9117"}
        ${genHandleFragment "@sonar" "sonar" ":8989"}
        ${genHandleFragment "@radar" "radar" ":7878"}

        handle /ok {
          respond "Ok this works"
        }
      '';
    in
    {
      enable = true;
      package = pkgs.cloudflare-caddy;
      # instead of readFile we should read the token from age or something like that
      logFormat = ''
        output stdout
      '';
      virtualHosts = {
        "media.burmudar.dev" = {
          extraConfig = cfgGen "media.burmudar.dev" "internal";
        };
        "media.raptor-emperor.ts.net" = {
          extraConfig = cfgGen "media.raptor-emperor.ts.net" "internal";
        };
        "media.internal" = {
          extraConfig = cfgGen "media.internal" "internal";
        };
      };
    };

  # because we're using a custom caddy package
  systemd.services.caddy. serviceConfig.AmbientCapabilities = "CAP_NET_BIND_SERVICE";

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
  };

  services.sonarr = {
    enable = true;
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
    record = "media";
  };

  services.syncthing = {
    enable = true;
    overrideFolders = true;
    extraOptions = {
      options = {
        listenAddresses = [
          "localhost:22000"
        ];
        minHomeDiskFree = {
          unit = "%";
          value = 1;
        };
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
        path = "/mnt/storage1/Downloads/nzb";
        id = "nzb";
        devices = [ "seedbox" ];
        type = "sendreceive";
      };
      "Torrents" = {
        path = "/mnt/storage1/Downloads/torrents";
        id = "torrents";
        devices = [ "seedbox" ];
        type = "sendreceive";
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
