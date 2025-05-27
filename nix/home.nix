{ config, pkgs, unstable, lib, ... }@inputs:
rec {
  programs.home-manager.enable = true;

  home.stateVersion = "23.05";

  home.username = "william";

  home.homeDirectory = if pkgs.stdenv.isDarwin then lib.mkForce "/Users/${home.username}" else lib.mkForce "/home/${home.username}";

  home.file =
    let
      configHome = if pkgs.stdenv.isDarwin then config.home.homeDirectory else config.xdg.configHome;
      keepFile = name: pkgs.writeTextFile {
        name = "${name}";
        text = "# keep me";
      };
      files = {
        ".zwilliam".source = ../zsh/zwilliam;
        ".zwork".source = if pkgs.stdenv.isDarwin then ../zsh/zwork else keepFile ".zwork";
        "code/.keep".source = keepFile ".keep";
        ".ssh/config.d/.keep".source = keepFile ".keep";
        ".ssh/keys/.keep".source = keepFile ".keep";
        "${configHome}/${(if pkgs.stdenv.isDarwin then ".qutebrowser" else "qutebrowser")}/config.py".source = ../qutebrowser/config.py;
        "${configHome}/${(if pkgs.stdenv.isDarwin then ".qutebrowser" else "qutebrowser")}/userscripts".source = ../qutebrowser/userscripts;
        "${config.xdg.configHome}/i3/config".source = ../i3/config;
        "${config.xdg.configHome}/polybar/launch.sh".source = ../polybar/launch.sh;
        "${config.xdg.configHome}/polybar/config.ini".source = ../polybar/config.ini;
        "${config.xdg.configHome}/i3/i3lock.sh".source = ../i3/i3lock.sh;
        "${config.xdg.configHome}/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/dotfiles/vim";
      };
    in
    if pkgs.stdenv.isDarwin then
      files // {
        "${config.home.homeDirectory}/.hammerspoon".source = ../hammerspoon;
      }
    else
      files // { };

  home.shellAliases =
    let
      # these bash functions are defined in scripts.d/
      systemCmd = if pkgs.stdenv.isDarwin then "nix-darwin-sw" else "nix-sw";
    in
    {
      pass = "gopass";
      aenv = "source $(fd -s 'activate')";
      denv = "deactivate";
      grep = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";
      cat = "bat";
      bb = "bazel build";
      bt = "bazel test";
      bq = "bazel query";
      bc = "bazel configure";
      hsw = "cd $SRC/dotfiles && home-manager switch --flake 'nix/#mac'; cd -";
      ssw = "${systemCmd}";
    };

  home.packages = with pkgs; [
    cheat
    delta
    dogdns
    fd
    gping
    jq
    lsd
    procs
    dust
    duf
    broot
    procs
    ripgrep
    starship
    tldr
  ];

  xdg = if pkgs.stdenv.isDarwin then { enable = false; } else {
    enable = true;

    mimeApps = {
      enable = true;
      defaultApplications = if pkgs.stdenv.isDarwin then { } else {
        "text/html" = "org.qutebrowser.qutebrowser.desktop";
        "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
        "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
        "x-scheme-handler/about" = "org.qutebrowser.qutebrowser.desktop";
        "x-scheme-handler/unknown" = "org.qutebrowser.qutebrowser.desktop";
        "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
        "application/pdf" = "firefox.desktop";
        "application/zip" = "xfce4-file-manager.desktop";
      };

      associations.added = {
        "x-scheme-handler/tg" = "userapp-Telegram Desktop-M9XMU1.desktop;userapp-Telegram Desktop-A4JSW1.desktop;userapp-Telegram Desktop-2U9YZ1.desktop;userapp-Telegram Desktop-EKLZ01.desktop;userapp-Telegram Desktop-EC6S11.desktop;userapp-Telegram Desktop-IMV011.desktop;org.telegram.desktop.desktop";
        "application/pdf" = "firefox.desktop";
        "application/zip" = "xfce4-file-manager.desktop";
        "image/png" = "org.xfce.ristretto.desktop";
      };
    };
  };
  # software
  programs.firefox = {
    enable = pkgs.stdenv.isLinux;
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

      export VISUAL="nvim"
      export EDITOR="nvim"
      export DOCKER_HOST=unix://$($(which podman) machine inspect --format '{{.ConnectionInfo.PodmanSocket.Path}}')
    '';

    initExtra =
      let
        base = ''
          setopt EXTENDED_GLOB
          source ~/.zwilliam
          source ~/.zwork
        '';
      in
      if pkgs.stdenv.isDarwin then
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
      "media.tailscale" = {
        hostname = "media.raptor-emperor.ts.net";
        user = "william";
        identityFile = "~/.ssh/keys/burmkey.pem";
      };
      "media.*" = {
        hostname = "media.internal";
        user = "william";
        identityFile = "~/.ssh/keys/burmkey.pem";
      };
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/keys/burmkey.pem";
      };
      "mac.tailscale" = {
        user = "william";
        hostname = "Williams-MacBook-Pro.raptor-emperor.ts.net";
        identityFile = "~/.ssh/keys/burmkey.pem";
      };
      "mac" = {
        hostname = "Williams-MacBook-Pro.internal";
        user = "william";
        identityFile = "~/.ssh/keys/burmkey.pem";
      };
      "router" = {
        user = "root";
        hostname = "192.168.1.1";
        identityFile = "~/.ssh/keys/burmkey.pem";
      };
      "desktop.tailscale" = {
        user = "william";
        hostname = "fort-kickass.raptor-emperor.ts.net";
        identityFile = "~/.ssh/keys/burmkey.pem";
      };
      "desktop" = {
        user = "william";
        hostname = "fort-kickass.internal";
        identityFile = "~/.ssh/keys/burmkey.pem";
      };
      "spotipi" = {
        user = "pi";
        hostname = "spotipi.internal";
        identityFile = "~/.ssh//keys/burmkey.pem";
      };
      "bezuidenhout" = {
        user = "bezuidenhout";
        hostname = "bezuidenhout-pc";
        identityFile = "~/.ssh/keys/burmkey.pem";
      };
    };
  };

  programs.lsd = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    # Add 'william.bezuidenhout+github.com' to the gpg keys
    userEmail = if pkgs.stdenv.isDarwin then "william.bezuidenhout@sourcegraph.com" else "william.bezuidenhout@gmail.com";
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
      log-me = "log --author=\"${programs.git.userName}\" --pretty=format:\"%ad %h %s\" --date=short";
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
    enable = pkgs.stdenv.isLinux;
    enableZshIntegration = true;
    settings = {
      theme = "catppuccin-frappe";

      font-size = 13.0;
      font-family = "FiraCode Nerd Font";

      macos-option-as-alt = true;
    };
  };

  programs.kitty = {
    enable = true;
    package = pkgs.kitty;
    theme = "Catppuccin-Frappe";
    font = {
      package = pkgs.nerd-fonts.fira-code;
      name = "FiraCode Nerd Font";
      size = 13.0;
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

  # services
  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;

    defaultCacheTtl = 3600 * 4;

    pinentry.package = if pkgs.stdenv.isLinux then pkgs.pinentry-rofi else pkgs.pinentry_mac;

    extraConfig = ''
      allow-loopback-pinentry
    '';
  };

}
