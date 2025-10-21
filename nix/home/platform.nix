{ config, pkgs, lib, ... }:
{
  xdg = if pkgs.stdenv.isDarwin then { enable = false; } else {
    enable = true;

    mimeApps = {
      enable = true;
      defaultApplications = if pkgs.stdenv.isDarwin then { } else {
        # Web + Protocol handlers → LibreWolf
        "text/html" = "librewolf.desktop";
        "x-scheme-handler/http" = "librewolf.desktop";
        "x-scheme-handler/https" = "librewolf.desktop";
        "x-scheme-handler/about" = "librewolf.desktop";
        "x-scheme-handler/unknown" = "librewolf.desktop";

        # Telegram links
        "x-scheme-handler/tg" = "org.telegram.desktop.desktop";

        # Open PDFs in LibreWolf
        "application/pdf" = "librewolf.desktop";

        # ZIP files → Nautilus (instead of XFCE file manager)
        "application/zip" = "org.gnome.Nautilus.desktop";
      };

      associations.added = {
        # Telegram handlers
        "x-scheme-handler/tg" =
          "userapp-Telegram Desktop-M9XMU1.desktop;"
          + "userapp-Telegram Desktop-A4JSW1.desktop;"
          + "userapp-Telegram Desktop-2U9YZ1.desktop;"
          + "userapp-Telegram Desktop-EKLZ01.desktop;"
          + "userapp-Telegram Desktop-EC6S11.desktop;"
          + "userapp-Telegram Desktop-IMV011.desktop;"
          + "org.telegram.desktop.desktop";

        # PDFs → LibreWolf
        "application/pdf" = "librewolf.desktop";

        # ZIP → Nautilus
        "application/zip" = "org.gnome.Nautilus.desktop";

        # Images → Ristretto (or change to `org.gnome.eog.desktop` for Eye of GNOME)
        "image/png" = "org.xfce.ristretto.desktop";
      };
    };

    dconf = if pkgs.stdenv.isDarwin then { } else {
      settings = {
        "org/gnome/desktop/session" = {
          idle-delay = lib.hm.gvariant.mkUint32 3600;
        };
        "org/gnome/desktop/screensaver" = {
          lock-delay = lib.hm.gvariant.mkUint32 0;
        };
      };
    };
  }
