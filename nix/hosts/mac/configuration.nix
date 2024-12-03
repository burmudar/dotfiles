{ config, pkgs, unstable, ... }@inputs:
{
  system.stateVersion = 5;
  users.users.william = {
    home = /Users/william;
  };
  # From https://gist.github.com/jmatsushita/5c50ef14b4b96cb24ae5268dab613050
  # Without this, home-manager user packages doesn't work properly
  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  # Make sure the nix daemon always runs
  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nixVersions.stable;
    settings = {
      trusted-users = [ "root" "keegan" ];
      trusted-substituters = [ "https://sourcegraph-keegan.cachix.org" ];
    };
    gc = {
      automatic = true;
      interval = { Weekday = 0; Hour = 0; Minute = 0; };
      options = "--delete-older-than 60d";
    };
  };

  networking.dns = [ "192.168.1.1" "1.1.1.1" "8.8.8.8" ];
  networking.hostName = "Williams-MacBook-Pro";
  networking.knownNetworkServices = [ "Wi-Fi" "Ethernet Adaptor" "Thunderbolt Ethernet" ];

  # services.tailscale = {
  #   enable = true;
  #   package = unstable.tailscale;
  # };

  environment.systemPackages = with pkgs; [
    (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    age
    comma
    fd
    home-manager
    (nerdfonts.override {
      fonts = [
        "JetBrainsMono"
        "Hack"
        "FiraCode"
        "Noto"
      ];
    })
    hledger
    unstable.go
    unstable.gopls
    jq
    unstable.jujutsu
    kitty
    unstable.neovim
    nil
    nixpkgs-fmt
    nodePackages.pnpm
    nodePackages.typescript-language-server
    nodejs_20
    passage
    racket
    zig
    zk
  ];

  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;

    brews = [
      "ibazel"
      "bazelisk"
    ];
    # updates homebrew packages on activation,
    # can make darwin-rebuild much slower (otherwise i'd forget to do it ever though)
    casks = [
      "1password"
      "1password-cli"
      "amethyst"
      "calibre"
      "chromium"
      "discord"
      "docker"
      "element"
      "firefox"
      "font-jetbrains-mono-nerd-font"
      "hammerspoon"
      "iina"
      "intellij-idea-ce"
      "linear-linear"
      "loom"
      "notion"
      "notion-calendar"
      "obsidian"
      "p4v"
      "perforce"
      "postico"
      "qutebrowser"
      "raycast"
      "skype"
      "slack"
      "spotify"
      "steam"
      "sublime-merge"
      "tailscale"
      "telegram-desktop"
      "vlc"
      "zed"
      "zoom"
    ];
  };
}
