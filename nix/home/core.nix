{ config
, pkgs
, unstable ? pkgs
, lib
, ...
}:
rec {
  # Core home-manager settings
  programs.home-manager.enable = true;
  home.stateVersion = "23.05";
  home.username = "william";
  home.homeDirectory =
    if pkgs.stdenv.isDarwin then
      lib.mkForce "/Users/${home.username}"
    else
      lib.mkForce "/home/${home.username}";

  home.packages = with pkgs; [
    cheat
    delta
    doggo
    fd
    gping
    gopass
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

  xdg.configFile = let
      userHome = config.home.homeDirectory;
      dotfilesDir = "${userHome}/code/dotfiles";
      mkLink = config.lib.file.mkOutOfStoreSymlink;
    in {
      # Hyprland configuration
    "hypr".source = mkLink "${dotfilesDir}/hyprland";

    # Ghostty configuration
    "ghostty/config".source = mkLink "${dotfilesDir}/ghostty/config";

    # Mako notification daemon configuration
    "mako/config".source = mkLink "${dotfilesDir}/mako/config";

    # Wofi launcher configuration
    "wofi/config".source = mkLink "${dotfilesDir}/wofi/config";
    "wofi/style.css".source = mkLink "${dotfilesDir}/wofi/style.css";
    ".agents/skills".source = mkLink "${dotfilesDir}/skills";

    "i3/i3lock.sh".source = ../../i3/i3lock.sh;
    "nvim".source = mkLink "${dotfilesDir}/vim";
    };

  home.file =
    let
      configHome = if pkgs.stdenv.isDarwin then config.home.homeDirectory else config.xdg.configHome;
      userHome = config.home.homeDirectory;
      dotfilesDir = "${userHome}/code/dotfiles";
      mkLink = config.lib.file.mkOutOfStoreSymlink;
      keepFile =
        name:
        pkgs.writeTextFile {
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
        "${configHome}/${
          (if pkgs.stdenv.isDarwin then ".qutebrowser" else "qutebrowser")
        }/config.py".source =
          ../../qutebrowser/config.py;
        "${configHome}/${
          (if pkgs.stdenv.isDarwin then ".qutebrowser" else "qutebrowser")
        }/userscripts".source =
          ../../qutebrowser/userscripts;

        "code/notes/.zk/templates".source = mkLink "${dotfilesDir}/zk/templates";

        # pi
        ".pi/agent/settings.json".source = mkLink "${dotfilesDir}/agents/pi/settings.json";
        "code/bin/pi".source = mkLink "${dotfilesDir}/agents/pi/pi";
      };
    in
    if pkgs.stdenv.isDarwin then
      files
      // {
        "${userHome}/.hammerspoon".source = ../../hammerspoon;
      }
    else
      files // { };



}
