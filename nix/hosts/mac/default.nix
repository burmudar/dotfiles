{ config, pkgs, ... }@inputs:
{
  users.users.william = {
    home = /Users/william;
  };
  # From https://gist.github.com/jmatsushita/5c50ef14b4b96cb24ae5268dab613050
  # Without this, home-manager user packages doesn't work properly
  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  # Make sure the nix daemon always runs
  services.nix-daemon.enable = true;
  # Installs a version of nix, that dosen't need "experimental-features = nix-command flakes" in /etc/nix/nix.conf
  nix.package = pkgs.nixFlakes;

  networking.dns = [ "192.168.1.1" "1.1.1.1" "8.8.8.8" ];
  networking.hostName = "Williams-MacBook-Pro";
  networking.knownNetworkServices = [ "Wi-Fi" "Ethernet Adaptor" "Thunderbolt Ethernet" ];

  services.tailscale = {
    enable = true;
  };

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
    inputs.unstable.go
    inputs.unstable.gopls
    jq
    kitty
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


    taps = [
      {
        name = "withgraphite/tap";
      }
    ];

    brews = [
      "ibazel"
      "bazelisk"
      "rustup"
      "withgraphite/tap/graphite"
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
      "loom"
      "linear-linear"
      "notion"
      "notion-calendar"
      "obsidian"
      "p4v"
      "perforce"
      "postico"
      "raycast"
      "skype"
      "slack"
      "spotify"
      "steam"
      "sublime-merge"
      "tailscale"
      "telegram-desktop"
      "qutebrowser"
      "vlc"
      "zed"
      "zoom"
    ];
  };
}
