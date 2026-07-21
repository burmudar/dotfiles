{ config, pkgs, lib, ... }:
{
  programs.noctalia = {
    enable = pkgs.stdenv.isLinux;

    settings = {
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };

      wallpaper = {
        enabled = true;
        default.path = "~/Pictures/wallpaper-0.png";
      };

  };
  };
}
