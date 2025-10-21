{ config, pkgs, unstable ? pkgs, lib, ... }:
rec {
  # Core home-manager settings
  programs.home-manager.enable = true;
  home.stateVersion = "23.05";
  home.username = "william";
  home.homeDirectory = if pkgs.stdenv.isDarwin then lib.mkForce "/Users/${home.username}" else lib.mkForce "/home/${home.username}";

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
    ripgrep
    starship
    tldr
  ];

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
      ssw = "${systemCmd}";
    };

  home.file =
    let
      configHome = if pkgs.stdenv.isDarwin then config.home.homeDirectory else config.xdg.configHome;
      keepFile = name: pkgs.writeTextFile {
        name = "${name}";
        text = "# keep me";
      };
      files = {
        ".zwilliam".source = ../../zsh/zwilliam;
        ".zwork".source = if pkgs.stdenv.isDarwin then ../../zsh/zwork else keepFile ".zwork";
        "code/.keep".source = keepFile ".keep";
        "code/bin/.keep".source = keepFile ".keep";
        ".ssh/config.d/.keep".source = keepFile ".keep";
        ".ssh/keys/.keep".source = keepFile ".keep";
        "${configHome}/${(if pkgs.stdenv.isDarwin then ".qutebrowser" else "qutebrowser")}/config.py".source = ../../qutebrowser/config.py;
        "${configHome}/${(if pkgs.stdenv.isDarwin then ".qutebrowser" else "qutebrowser")}/userscripts".source = ../../qutebrowser/userscripts;
        
        # Hyprland configuration
        "${config.xdg.configHome}/hypr/hyprland.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/dotfiles/hyprland/hyprland.conf";
        "${config.xdg.configHome}/hypr/monitors.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/dotfiles/hyprland/monitors.conf";
        "${config.xdg.configHome}/hypr/envs.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/dotfiles/hyprland/envs.conf";
        "${config.xdg.configHome}/hypr/looknfeel.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/dotfiles/hyprland/looknfeel.conf";
        "${config.xdg.configHome}/hypr/input.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/dotfiles/hyprland/input.conf";
        "${config.xdg.configHome}/hypr/bindings.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/dotfiles/hyprland/bindings.conf";
        "${config.xdg.configHome}/hypr/windows.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/dotfiles/hyprland/windows.conf";
        "${config.xdg.configHome}/hypr/autostart.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/dotfiles/hyprland/autostart.conf";
        "${config.xdg.configHome}/hypr/hyprlock.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/dotfiles/hyprland/hyprlock.conf";
        "${config.xdg.configHome}/hypr/hypridle.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/dotfiles/hyprland/hypridle.conf";
        
        # Ghostty configuration
        "${config.xdg.configHome}/ghostty/config".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/dotfiles/ghostty/config";
        
        # Mako notification daemon configuration
        "${config.xdg.configHome}/mako/config".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/dotfiles/mako/config";
        
        # Wofi launcher configuration
        "${config.xdg.configHome}/wofi/config".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/dotfiles/wofi/config";
        "${config.xdg.configHome}/wofi/style.css".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/dotfiles/wofi/style.css";
        
        # Disabled 16 Aug 2025 - moving to hyprland
        # "${config.xdg.configHome}/i3/config".source = ../../i3/config;
        # "${config.xdg.configHome}/polybar/launch.sh".source = ../../polybar/launch.sh;
        # "${config.xdg.configHome}/polybar/config.ini".source = ../../polybar/config.ini;
        "${config.xdg.configHome}/i3/i3lock.sh".source = ../../i3/i3lock.sh;
        "${config.xdg.configHome}/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/dotfiles/vim";
      };
    in
    if pkgs.stdenv.isDarwin then
      files // {
        "${config.home.homeDirectory}/.hammerspoon".source = ../../hammerspoon;
      }
    else
      files // { };
}
