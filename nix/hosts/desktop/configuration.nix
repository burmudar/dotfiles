# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, config, ... }@inputs:
let
  username = "william";
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./ergodox.nix
      ./vm.nix
    ];

  home-manager.backupFileExtension = "bak";

  boot.supportedFilesystems = [ "ntfs" ];
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;

  networking.hostName = "fort-kickass"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  # disabled otherwise it fails on switch
  systemd.services.NetworkManager-wait-online.enable = false;

  # Set your time zone.
  time.timeZone = "Africa/Johannesburg";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  services = {
    # Need so that qmk can see the keyboard
    udev.packages = [ pkgs.qmk-udev-rules ];
    blueman.enable = true;
    dbus.enable = true;

    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
      displayManager = {
        autoLogin = {
          user = username;
          enable = true;
        };
        gdm = {
          enable = true;
          wayland = true;
        };
        # sessionCommands = ''
        #   ${pkgs.xorg.xset}/bin/xset r rate 200 40
        # '';
      };

      displayManager = {
        defaultSession = "hyprland";
      };
    };
    gvfs.enable = true;
    tumbler.enable = true;
    hypridle.enable = true;

    printing.enable = true;

    # trim filesystem - useful for SSD
    fstrim.enable = true;

    # sound
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      jack.enable = true;
      wireplumber.enable = true;
    };
    pulseaudio.enable = false;


    avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        addresses = true;
        domain = true;
        enable = true;
      };
    };


    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

    tailscale.enable = true;
  };

  # Enable CUPS to print documents.
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ inputs.hyprland.xdg-desktop-portal-hyprland ];
  };

  programs = {
    hyprland = {
      enable = true;
      package = inputs.hyprland.hyprland;
      portalPackage = inputs.hyprland.xdg-desktop-portal-hyprland;
      xwayland.enable = true;
    };
    hyprlock.enable = true;

    zsh.enable = true;
    mtr.enable = true;
    wireshark.enable = true;
    noisetorch.enable = true;

    neovim.viAlias = true;
    neovim.vimAlias = true;

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

  };

  security.rtkit.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # set in Home manager
  users.defaultUserShell = pkgs.zsh;
  users.users."${username}" = {
    isNormalUser = true;
    description = "William Bezuidenhout";
    extraGroups = [ "input" "networkmanager" "wheel" "docker" "vboxusers" "libvirtd" "wireshark" "tty" "dialout" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6iuO9BMUxIaDlnUbRjPAi4d44nvEL4mSbTqUWAw53xEC9tRKGi7HxXBGVZzT6riDBdaI5Kibxj4fWMt3SMnSbxSjFOleS7iNRjjKyEGUnnpekVCHtye2tNDaRvnKwK4/ZG8Kd/t/aKYyWmPZJEVfWUM3iiFgBHh/3ml0Zgb/Y0QCxP7FdIyCeMY3f8AW6wGVfNH3BBvRlpQt+rNwYmp/kmsrxalgUGpzHOlpKQbzh+0Ox5I73RF+nK7VBJA6OAan6n7zyfy40y/LwQieckqbi2Jogd438G8iqnQYkIXFCMV8IFCQ4wjAnDvdfOBysdKlxwS+1ZNHv0UGHT4jbRw0N william.bezuidenhout+ssh@gmail.com" ];

  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alacritty
    xorg.xrandr
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    bash
    btrfs-progs
    curl
    difftastic
    customNodePackages."@anthropic-ai/claude-code"
    clipse
    feh
    scrot
    fd
    flameshot
    gcc
    git
    gnumake
    grub2
    htop
    i3lock
    imagemagick
    jq
    kitty
    krita
    lua
    mako
    hyprpolkitagent
    hyprpaper
    hyprlock
    hypridle
    man-pages
    man-pages-posix
    nix-direnv
    networkmanagerapplet
    nmap
    nodePackages.typescript-language-server
    nodejs_20
    nautilus
    openssl.dev
    os-prober
    pavucontrol
    pipewire
    pkg-config
    podman-tui
    python3
    qmk
    racket
    rust-bin.stable.latest.default
    egl-wayland
    lua-language-server
    luarocks
    spotify
    prusa-slicer
    tdesktop # telegram
    tmux
    unzip
    vlc
    warsow
    waybar
    wttrbar
    wget
    where-is-my-sddm-theme
    whitesur-cursors
    whitesur-gtk-theme
    whitesur-icon-theme
    wofi
    wl-clipboard
    xclip
    zk
    # Hyprland tools
    grim # Screenshot utility
    slurp # Screen area selection
    hyprpicker # Color picker
    wlogout # Logout menu
    playerctl # Media player control
    brightnessctl # Brightness control
  ] ++ (with inputs.unstable; [
    git-spice
    freecad
    inputs.ghostty.default
    go
    gopls
    neovim
    obsidian
    qutebrowser
  ]);


  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "william" ];
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
    gc = {
      dates = "weekly";
      options = "--delete-older-than 60d";
    };
    optimise.automatic = true;
  };

  # needed for hyprland and electron
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.pathsToLink = [ "/share/nix-direnv" ];
  environment.shells = with pkgs; [ zsh ];

  fonts = {
    enableDefaultFonts = true;
    enableGhostscriptFonts = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
        monospace = [ "Caskaydia Mono Nerd Font" ];
      };
    };
    packages = with pkgs; [
      font-awesome
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
    ] ++ (with nerd-fonts; [ caskaydia-cove hack jetbrains-mono fira-code fira-code-symbols ]);
  };


  virtualisation = {
    containers.enable = true;
    virtualbox.host.enable = true;
    libvirtd.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

  # Needed otherwise we get some binaries complaining that they can't find glibc
  system.activationScripts.ldso = pkgs.lib.stringAfter [ "usrbinenv" ] ''
    mkdir -m 0755 -p /lib64
    ln -sfn ${pkgs.glibc.out}/lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2.tmp
    mv -f /lib64/ld-linux-x86-64.so.2.tmp /lib64/ld-linux-x86-64.so.2 # atomically replace
  '';

}
