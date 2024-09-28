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
        "${configHome}/${(if pkgs.stdenv.isDarwin then ".qutebrowser" else "qutebrowser")}/config.py".source = ../qutebrowser/config.py;
        "${configHome}/${(if pkgs.stdenv.isDarwin then ".qutebrowser" else "qutebrowser")}/userscripts".source = ../qutebrowser/userscripts;
        "${config.xdg.configHome}/i3/config".source = ../i3/config;
        "${config.xdg.configHome}/polybar/launch.sh".source = ../polybar/launch.sh;
        "${config.xdg.configHome}/polybar/config.ini".source = ../polybar/config.ini;
        "${config.xdg.configHome}/i3/i3lock.sh".source = ../i3/i3lock.sh;
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
      systemCmd = if pkgs.stdenv.isDarwin then "darwin-rebuild switch --flake nix/." else "sudo nixos-rebuild switch --flake nix/.";
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
      ssw = "cd $SRC/dotfiles && ${systemCmd}; cd -";
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
    ripgrep
    starship
    tldr
  ];

  xdg = {
    enable = true;
  };
  # software
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

  # Currently broken
  # programs.qutebrowser = {
  #   enable = true;
  #   package = inputs.pkgs.qutebrowser;
  #   extraConfig = (builtins.readFile ../qutebrowser/config.py);
  # };



  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    package = unstable.neovim;
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
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
          export PATH=$PATH:/usr/local/bin
          source ~/.cargo/env
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
    forwardAgent = true;
    includes = [
      "~/.ssh/config.d/*"
    ];
    matchBlocks = {
      "media.tailscale" = {
        hostname = "media.raptor-emperor.ts.net";
        user = "william";
        identityFile = "~/.ssh/keys/burmkey.pvt";
      };
      "media.*" = {
        hostname = "media.internal";
        user = "william";
        identityFile = "~/.ssh/keys/burmkey.pvt";
      };
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/keys/burmkey.pvt";
      };
      "mac.tailscale" = {
        user = "william";
        hostname = "Williams-MacBook-Pro.raptor-emperor.ts.net";
        identityFile = "~/.ssh/keys/burmkey.pvt";
      };
      "mac" = {
        hostname = "Williams-MacBook-Pro.internal";
        user = "william";
        identityFile = "~/.ssh/keys/burmkey.pvt";
      };
      "router" = {
        user = "root";
        hostname = "192.168.1.1";
        identityFile = "~/.ssh/keys/burmkey.pvt";
      };
      "desktop.tailscale" = {
        user = "william";
        hostname = "fort-kickass.raptor-emperor.ts.net";
        identityFile = "~/.ssh/keys/burmkey.pvt";
      };
      "desktop" = {
        user = "william";
        hostname = "fort-kickass.internal";
        identityFile = "~/.ssh/keys/burmkey.pvt";
      };
      "spotipi" = {
        user = "pi";
        hostname = "spotipi.internal";
        identityFile = "~/.ssh//keys/burmkey.pvt";
      };
      "bezuidenhout" = {
        user = "bezuidenhout";
        hostname = "bezuidenhout-pc";
        identityFile = "~/.ssh/keys/burmkey.pvt";
      };
    };
  };

  programs.lsd = {
    enable = true;
    enableAliases = true;
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
      s = "status";
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
    };

    delta = {
      enable = true;
      options = {
        side-by-side = true;
        line-numbers = true;
      };
    };
  };

  programs.alacritty = {
    enable = false;
    package = pkgs.alacritty;
    settings = {
      window = {
        decorations = "none";
        padding = { x = 2; y = 2; };
        startup_mode = "Maximized";
        dynamic_title = true;
        option_as_alt = "OnlyLeft";
      };
      font = {
        size = if pkgs.stdenv.isDarwin then 12.0 else 10.00;
        normal = {
          family = "JetBrainsMono Nerd Font Mono";
          style = "Medium";
        };
      };
    };
  };

  programs.kitty = {
    enable = true;
    package = pkgs.kitty;
    theme = "Dracula";
    font = {
      package = with pkgs; (nerdfonts.override { fonts = [ "FiraCode" ]; });
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

  # services
  services.gpg-agent = {
    enable = pkgs.stdenv.isLinux;
    enableSshSupport = true;
    enableZshIntegration = true;

    defaultCacheTtl = 3600 * 4;

    pinentryPackage = pkgs.pinentry-curses;

    extraConfig = ''
      allow-loopback-pinentry
    '';
  };
}
