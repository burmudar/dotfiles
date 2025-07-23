{ config, pkgs, unstable ? pkgs, lib, ... }:
let
  # Platform detection
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

  # Common values
  defaultIdentityFile = "~/.ssh/keys/burmkey.pem";
  defaultUser = "william";
  fontSize = 13.0;
  fontFamily = "Hack Nerd Font Mono";
  theme = "catppuccin-frappe";

  # SSH host configuration helpers
  mkSSHHost = { hostname, user ? defaultUser, identityFile ? defaultIdentityFile }: {
    inherit hostname user identityFile;
  };
in
{
  programs.firefox = {
    enable = isLinux;
    package = pkgs.librewolf;
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      Preferences = {
        "cookiebanners.service.mode.privateBrowsing" = 2; # Block cookie banners in private browsing
        "cookiebanners.service.mode" = 2; # Block cookie banners
        "privacy.donottrackheader.enabled" = true;
        "privacy.fingerprintingProtection" = true;
        "privacy.resistFingerprinting" = true;
        "privacy.trackingprotection.emailtracking.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.fingerprinting.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
      };
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "ansi";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      aws.disabled = true;
      gcloud.disabled = true;
      nodejs.disabled = true;
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
  };

  programs.k9s = {
    enable = true;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    package = unstable.neovim;
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    package = unstable.atuin;
    settings = {
      auto_sync = true;
      style = "compact";
      sync_frequency = "5m";
      sync_address = "https://api.atuin.sh";
      search_mode = "fuzzy";
    };
  };

  programs.zsh = {
    enable = true;
    package = unstable.zsh;
    syntaxHighlighting = {
      enable = true;
    };
    enableVteIntegration = true;
    enableCompletion = true;

    envExtra = ''
      export SRC=~/code
      export LC_ALL=en_US.UTF-8
      export LANG=en_US.UTF-8
      export TERM=screen-256color
      export PATH="$PATH:$HOME/code/bin"

      export VISUAL="nvim"
      export EDITOR="nvim"
      if command -v podman >/dev/null 2>&1 && podman machine list --format "{{.Name}}" | grep -q .; then
        export DOCKER_HOST=unix://$(podman machine inspect --format '{{.ConnectionInfo.PodmanSocket.Path}}')
      fi
    '';

    initContent =
      let
        base = ''
          setopt EXTENDED_GLOB
          source ~/.zwilliam
          source ~/.zwork
        '';
      in
      if isDarwin then
        ''
          ${base}
          eval "$(/opt/homebrew/bin/brew shellenv)"
          export PATH=$PATH:/usr/local/bin
          if [ -f ~/.cargo/env ]; then
            source ~/.cargo/env
          fi
        ''
      else
        base;
  };

  programs.tmux = {
    enable = true;

    clock24 = true;
    baseIndex = 1;
    escapeTime = 50;
    historyLimit = 10000;
    keyMode = "vi";
    mouse = true;
    shortcut = "b";
    prefix = "C-a";
    terminal = "screen-256color";

    plugins = with pkgs.tmuxPlugins; [
      yank
      vim-tmux-navigator
      vim-tmux-focus-events
      gruvbox
    ];

    extraConfig = ''
      set -g renumber-windows on
      set -g default-command ${pkgs.zsh}/bin/zsh
      set-option -g visual-activity off
      set-option -g visual-bell off
      set-option -g visual-silence off
      set-option -sa terminal-features ',screen-256color:RGB'

      # keybindings
      bind-key C-s set-window-option synchronize-panes\; display-message "synchronize-panes is now #{?pane_synchronized,on,off}"
      bind-key -T root M-j run-shell $SRC/dotfiles/tmux/popupmx.sh
      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind %

      # without this, vim scrolling lags
      set-option -s escape-time 10

      # Set terminal title to current pane title
      set -g set-titles on
      set -g set-titles-string "#{pane_title}"
    '';
  };

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    forwardAgent = true;
    includes = [
      "~/.ssh/config.d/*"
    ];
    matchBlocks = {
      "media.tailscale" = mkSSHHost { hostname = "media.raptor-emperor.ts.net"; };
      "media.*" = mkSSHHost { hostname = "media.internal"; };
      "github.com" = mkSSHHost { hostname = "github.com"; user = "git"; };
      "mac.tailscale" = mkSSHHost { hostname = "Williams-MacBook-Pro.raptor-emperor.ts.net"; };
      "mac" = mkSSHHost { hostname = "Williams-MacBook-Pro.internal"; };
      "router" = mkSSHHost { hostname = "192.168.1.1"; user = "root"; };
      "desktop.tailscale" = mkSSHHost { hostname = "fort-kickass.raptor-emperor.ts.net"; };
      "desktop" = mkSSHHost { hostname = "fort-kickass.internal"; };
      "spotipi" = mkSSHHost { hostname = "spotipi.internal"; user = "pi"; };
      "bezuidenhout" = mkSSHHost { hostname = "bezuidenhout-pc"; user = "bezuidenhout"; };
    };
  };

  programs.lsd = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    # Add 'william.bezuidenhout+github.com' to the gpg keys
    userEmail = if isDarwin then "william.bezuidenhout@sourcegraph.com" else "william.bezuidenhout@gmail.com";
    userName = "William Bezuidenhout";
    signing = {
      signByDefault = true;
      key = "EDE8072F89D58CD9!";
    };
    aliases = {
      st = "status";
      co = "checkout";
      c = "commit";
      cm = "commit -m";
      ca = "commit --amend";
      nb = "switch -c";
      ps = "push";
      psf = "push --force-with-lease";
      psu = "push -u";
      pl = "pull";
      plr = "pull --rebase";
      f = "fetch";
      ap = "add -p";
      log-me = "log --author=\"${config.programs.git.userName}\" --pretty=format:\"%ad %h %s\" --date=short";
      pristine = "clean -dx -e .envrc -e .direnv -e server/env.local";
    };
    extraConfig = {
      push.autoSetupRemote = true;
      rerere.enabled = true;
      url = {
        "ssh://git@github.com/" = {
          insteadOf = "https://github.com/";
        };
      };
    };

    delta = {
      enable = true;
      options = {
        side-by-side = true;
        line-numbers = true;
      };
    };
  };

  programs.ghostty = {
    enable = isLinux;
    enableZshIntegration = true;
    settings = {
      inherit theme;
      font-size = fontSize;
      font-family = fontFamily;
      macos-option-as-alt = true;
    };
  };

  programs.kitty = {
    enable = true;
    package = pkgs.kitty;
    themeFile = "Catppuccin-Frappe";
    font = {
      package = pkgs.nerd-fonts.fira-code;
      name = fontFamily;
      size = fontSize;
    };
    keybindings = {
      "cmd+k>w" = "close_tab";
      "cmd+w" = "no-op";
      "cmd+c" = "copy_to_clipboard";
      "cmd+v" = "paste_from_clipboard";
    };
    settings = {
      input_delay = 2;
      sync_to_monitor = true;
      enable_audio_bell = false;
      macos_option_as_alt = true;
      macos_titlebar_color = "background";
      hide_window_decorations = true;
      open_url_modifiers = "cmd";
      tab_bar_style = "powerline";
      tab_bar_separator = " ";
      tab_bar_background = "none";
      shell_integration = true;

      copy_on_select = true;
    };
    extraConfig = ''
      macos_thicken_font 0.4
      window_padding_width 2.0
    '';
  };

  programs.gpg = {
    enable = true;
    # if this key is not found then loading home manager fails
    # publicKeys = [
    #   { text = "EDE8072F89D58CD9!"; trust = 5; }
    # ];
  };

  services.gpg-agent = let
    one_day = 3600 * 24;
    in {
    enable = true;
    enableExtraSocket = true;
    enableSshSupport = true;
    enableZshIntegration = true;

    defaultCacheTtl = one_day;
    defaultCacheTtlSsh = one_day;
    maxCacheTtl = one_day;
    maxCacheTtlSsh = one_day;

    pinentry.package = if isLinux then pkgs.pinentry-rofi else pkgs.pinentry_mac;

    extraConfig = ''
      allow-loopback-pinentry
    '';
  };
}
