{ config, pkgs, unstable, hostname, personal, ... }@inputs:
let
  lib = pkgs.lib;
  personal = lib.defaultTo false inputs.personal;
  isWork = !personal;
in
{
  system = {
    stateVersion = 5;
    defaults = {
      # https://daiderd.com/nix-darwin/manual/index.html
      NSGlobalDomain = {
        # https://mac-key-repeat.zaymon.dev/
        InitialKeyRepeat = 10; # 120 ms
        KeyRepeat = 1; # 15 ms
      };
    };
  };
  users.users.william = {
    home = /Users/william;
  };

  home-manager.backupFileExtension = "bak";
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

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
    lua-language-server
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
      "pinentry-mac"
      "podman"
      "starship"
    ] ++ lib.optionals isWork [ "bazelisk" "ibazel" "mise" ];
    # updates homebrew packages on activation,
    # can make darwin-rebuild much slower (otherwise i'd forget to do it ever though)
    casks = [
      "slack"
      "calibre"
      "claude"
      "chatgpt"
      "discord"
      "element"
      "firefox"
      "font-jetbrains-mono-nerd-font"
      "google-chrome"
      "hammerspoon"
      "ghostty"
      "iina"
      "podman-desktop"
      "postico"
      "raycast"
      "spotify"
      "steam"
      "sublime-merge"
      "tailscale"
      "telegram-desktop"
      "qutebrowser"
      "vlc"
      "visual-studio-code"
    ] ++ lib.optionals isWork [ "1password" "1password-cli" "docker" "linear-linear" "loom" "notion" "notion-calendar" "p4v" "perforce" ];
  };
}
