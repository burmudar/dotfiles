{ config, pkgs, unstable, hostname, ... }@inputs:
let
  lib = pkgs.lib;
  personal = lib.attrByPath ["personal"] false inputs;
  isWork = !personal;
in
{
  system = {
    primaryUser = "william";
    stateVersion = 5;
    defaults = {
      # https://daiderd.com/nix-darwin/manual/index.html
      NSGlobalDomain = {
        # https://mac-key-repeat.zaymon.dev/
        InitialKeyRepeat = 10; # 120 ms
        KeyRepeat = 2; # 15 ms
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
    uv
    fswatch
    fzf
    git
    github-cli
    gopass
    hledger
    jq
    k9s
    kitty
    kubectl
    kubectx
    luarocks
    lua-language-server
    nil
    nixpkgs-fmt
    # All the below seem to ignore the nodejs version and want v20
    # nodePackages.typescript-language-server
    # typescript-language-server
    # nodejs_22.pkgs.typescript-language-server
    nodePackages.pnpm # works ... pnpm node --verison = v22
    passage
    zig
  ] ++ (with unstable; [
    go
    gopls
    jujutsu
  ]) ++ (with pkgs.nerd-fonts; [
    jetbrains-mono
    hack
    fira-code
    noto
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
      "chatgpt"
      "claude"
      "discord"
      "element"
      "firefox"
      "ghostty"
      "google-chrome"
      "hammerspoon"
      "iina"
      "podman-desktop"
      "postico"
      "qutebrowser"
      "raycast"
      "slack"
      "spotify"
      "steam"
      "sublime-merge"
      "tailscale"
      "telegram-desktop"
      "tuple"
      "visual-studio-code"
      "vlc"
    ] ++ lib.optionals isWork [ "1password" "1password-cli" "linear-linear" "loom" "notion" "notion-calendar" "p4v" "perforce" ];
  };
}
