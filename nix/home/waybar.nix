{ config, pkgs, lib, ... }:
{
  programs.waybar = {
  enable = true;
  settings = [
    {
      layer = "top";
      position = "top";
      autohide = true;
      autohide-blocked = false;
      exclusive = true;
      passthrough = false;
      height = 24;
      gtk-layer-shell = true;
      /* === Modules Order === */
      modules-left = [
        "tray"
        "custom/nixicon"
        "idle_inhibitor"
        "hyprland/workspaces"
      ];
      modules-center = [
          "custom/weather"
          "clock"
      ];
      modules-right = [
        #"wlr/taskbar"
        "cpu"
        "memory"
        "disk"
        "temperature"
        "wireplumber"
        "network"
        "custom/pwr_btn"
      ];
      "custom/nixicon" = {
        format = " 󱄅 ";
        on-click = "wofi --show drun";
        tooltip = false;
      };
      "custom/weather" = {
        tooltip = true;
        format = "{}";
        interval = 1800;
        exec = "wttrbar";
        return-type = "json";
      };
      "custom/pwr_btn" = {
        format = "  ";
        on-click = "sh -c '(sleep 0.5s; wlogout --protocol layer-shell)' & disown";
        tooltip = false;
      };
      clock = {
        timezone = "Africa/Johannesburg";
        format = "{:%H:%M}  ";
        format-alt = "{:%A, %B %d, %Y (%R)} 󰃰 ";
        tooltip-format = "<tt><small>{calendar}</small></tt>";
        calendar = {
          mode = "year";
          mode-mon-col = 3;
          weeks-pos = "right";
          on-scroll = 1;
          on-click-right = "mode";
          format = {
            months =     "<span color='#ffead3'><b>{}</b></span>";
            days =       "<span color='#ecc6d9'><b>{}</b></span>";
            weeks =      "<span color='#99ffdd'><b>W{}</b></span>";
            weekdays =   "<span color='#ffcc66'><b>{}</b></span>";
            today =      "<span color='#ff6699'><b><u>{}</u></b></span>";
          };
        };
        actions =  {
          on-click-right = "mode";
          on-click-forward = "tz_up";
          on-click-backward = "tz_down";
          on-scroll-up = "shift_up";
          on-scroll-down = "shift_down";
        };
      };
      cpu = {
        format = "{usage}% ";
        tooltip = true;
        tooltip-format = "Combined = {usage}%\ncores = {cores}";
      };
      memory = {
        format = "{}% 󰍛";
        tooltip = true;
        tooltip-format = "RAM usage = {used} / {total} ({percentage}%)";
      };
      disk = {
        format = "{percentage_free}% ";
        tooltip = true;
        tooltip-format = "Usage = {free} / {total} ({percentage_free}%)";
      };
      temperature = {
        format = "{temperatureC}°C {icon}";
        tooltip = true;
        tooltip-format = "Temp {temperatureC}°C";
        format-icons = [
          ""
        ];
      };
      "hyprland/workspaces" = {
        format = "{icon}";
        format-icons = {
          default = "";
          active = "";
        };
        persistent-workspaces = {
          "1" = []; /* show workspace 1 on all outputs */
        };
        disable-scroll = true;
        all-outputs = true;
        show-special = true;
      };
      "wlr/taskbar" = {
        format = "{icon}";
        all-outputs = true;
        active-first = true;
        tooltip-format = "{name}";
        on-click = "activate";
        on-click-middle = "close";
        ignore-list = [];
      };
      idle_inhibitor = {
        format = "{icon}";
        format-icons = {
          activated = "  ";
          deactivated = "  ";
        };
      };
      wireplumber = {
        format = "{volume}% {icon}";
        format-muted = " 󰝟 ";
        format-icons = [
          "  "
          "  "
          "  "
        ];
        on-click = "pavucontrol";
        scroll-step = 5;
        max-volume = 150;
        states = {
          high = 101;
        };
      };
      network = {
        format = "{ifname}";
        format-wifi = "󰘊 {ipaddr}";
        format-ethernet = "{ifname} 󰈀";
        format-disconnected = " ";
        tooltip-format = " {ifname} via {gwaddr}";
        tooltip-format-wifi = "{essid} [{signalStrength}%]\n{bandwidthDownBytes} 󰛀 {bandwidthUpBytes} 󰛃";
        tooltip-format-ethernet = " {ifname} {ipaddr}/{cidr}";
        tooltip-format-disconnected = "Disconnected";
        max-length = 50;
      };
      tray = {
        icon-size = 21;
        spacing = 10;
        icons = {
            TelegramDesktop = "$HOME/.local/share/icons/hicolor/16x16/apps/telegram.png";
        };
      };
    }
  ];
  style = ''
    * {
        border: none;
        border-radius: 0;
        font-family: "CaskaydiaCove Nerd Font Propo";
        font-weight: bold;
        font-size: 16px;
        min-height: 0;
    }

    window#waybar {
        background: rgba(21, 18, 27, 0);
        color: #f6f7fc;
    }

    #tooltip {
        background: #1e1e2e;
        opacity: 0.8;
        border-radius: 10px;
        border-width: 2px;
        border-style: solid;
        border-color: #11111b;
    }

    #tooltip label{
        color: #cdd6f4;
    }

  #workspaces button {
        padding: 5px;
        color: #f6f7fc;
        margin-right: 3px;
        margin-left: 3px;
        padding-right: 10px;
    }

  #workspaces button.active {
        color: #000000;
        background: #a6e3a1;
        border-radius: 10px;
    }

  #workspaces button:hover {
        background: #11111b;
        color: #cdd6f4;
        border-radius: 10px;
    }

  #custom-nixicon,
  #custom-pwr_btn,
  #custom-weather,
  #window,
  #ram,
  #disk,
  #cpu,
  #network,
  #memory,
  #clock,
  #wireplumber,
  #tray,
  #temperature,
  #workspaces,
  #idle_inhibitor {
        background: #1e1e2e;
        opacity: 1;
        padding: 0px 10px;
        margin: 3px 0px;
        margin-top: 5px;
        border: 0px;
    }

  #idle_inhibitor {
        padding-left: 0px;
    }

  #temperature.critical {
        color: #e92d4d;
    }

  #workspaces {
        padding-right: 0px;
        padding-left: 0px;
    }

  #window {
        border-radius: 10px;
        margin-left: 0px;
        margin-right: 0px;
    }

  #custom-weather {
        margin-left: 0px;
        border-right: 0px;
        font-size: 16px;
        margin-right: 0px;
        padding: 0px 5px;
    }

  #tray, #cpu, #wireplumber  {
        border-radius: 10px 0px 0px 10px;
        margin-left: 5px;
    }

  #idle_inhibitor, #custom-pwr_btn, #temperature {
        border-radius: 0px 10px 10px 0px;
        margin-right: 5px;
    }

  #clock, #workspaces, #custom-weather {
        border-radius: 10px;
        margin-right: 5px;
        margin-left: 5px;
  }
  '';
  };

}
