{ config, pkgs, unstable, hostname, ... }@inputs:
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
      experimental-features = [ "nix-command" "flakes" ];
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
  networking.hostName = hostname;
  networking.knownNetworkServices = [ "Wi-Fi" "Ethernet Adaptor (en2)" "Thunderbolt Bridge" ];

  # services.tailscale = {
  #   enable = true;
  #   package = unstable.tailscale;
  # };

  environment.systemPackages = with pkgs; [
    (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    age
    comma
    customNodePackages."@anthropic-ai/claude-code"
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
    fswatch
    fzf
    git
    github-cli
    gopass
    hledger
    jq
    k9s
    kitty
    luarocks
    nil
    nixpkgs-fmt
    nodePackages.pnpm
    nodePackages.typescript-language-server
    nodejs_20
    passage
    racket
    zig
  ] ++ (with unstable; [
    go
    gopls
    jujutsu
    neovim
  ]);

  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "zap";

    brews = [
      "bazelisk"
      "ibazel"
      "mise"
      "pinentry-mac"
      "podman"
      "starship"
    ];
    # updates homebrew packages on activation,
    # can make darwin-rebuild much slower (otherwise i'd forget to do it ever though)
    casks = [
      "1password"
      "1password-cli"
      "calibre"
      "claude"
      "discord"
      "docker"
      "element"
      "firefox"
      "font-jetbrains-mono-nerd-font"
      "google-chrome"
      "hammerspoon"
      "ghostty"
      "iina"
      "linear-linear"
      "loom"
      "notion"
      "notion-calendar"
      "obsidian"
      "p4v"
      "perforce"
      "podman-desktop"
      "postico"
      "raycast"
      "slack"
      "spotify"
      "steam"
      "sublime-merge"
      "tailscale"
      "telegram-desktop"
      "vlc"
      "visual-studio-code"
      "zed"
    ];
  };
}
