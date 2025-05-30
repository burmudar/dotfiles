{ config, pkgs, lib, ... }:
{
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
}
