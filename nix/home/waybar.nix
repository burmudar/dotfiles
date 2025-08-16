{ config, pkgs, lib, ... }:
{
  home.file = {
    ".config/waybar/theme.css" = {
      text = ''
/* Global settings */
* {
  font-family: "CaskaydiaCove Nerd Font", "Font Awesome 6 Free", "Font Awesome 6 Free Solid";
  font-weight: bold;
  font-size: 16px;
  color: #dcdfe1;
}

/* Transparent Waybar background */
#waybar {
  background-color: rgba(0, 0, 0, 0);
  border: none;
  box-shadow: none;
}

/* Unified style for all modules */
#workspaces,
#window,
#tray{
  /*background-color: rgba(29,31,46, 0.95);*/
  background-color: rgba(15,27,53,0.9);
  padding: 4px 6px; /* Maintain internal spacing */
  margin-top: 6px;  /* Increase external spacing */
  margin-left: 6px; /* Increase external spacing */
  margin-right: 6px; /* Increase external spacing */
  border-radius: 10px;
  border-width: 0px;
}

#clock,
#custom-power{
  background-color: rgba(15,27,53,0.9);
  margin-top: 6px; /* Leave space from the top of the screen */
  margin-right: 6px;
  /*margin-bottom: 4px;*/
  padding: 4px 2px; /* Maintain internal spacing */
  border-radius: 0 10px 10px 0;
  border-width: 0px;
}

#network,
#custom-lock{
  background-color: rgba(15,27,53,0.9);
  margin-top: 6px; /* Leave space from the top of the screen */
  margin-left: 6px;
  /*margin-bottom: 4px;*/
  padding: 4px 2px; /* Maintain internal spacing */
  border-radius: 10px 0 0 10px;
  border-width: 0px;
}

#custom-reboot,
#bluetooth,
#battery,
#pulseaudio,
#backlight,
#custom-temperature,
#memory,
#cpu{
  background-color: rgba(15,27,53,0.9);
  margin-top: 6px; /* Leave space from the top of the screen */
  /*margin-bottom: 4px;*/
  padding: 4px 2px; /* Maintain internal spacing */
  border-width: 0px;
}

#custpm-temperature.critical,
#pulseaudio.muted {
  color: #FF0000;
  padding-top: 0;
}

/* Slightly brighten on hover */
#bluetooth:hover,
#network:hover,
/*#tray:hover,*/
#backlight:hover,
#battery:hover,
#pulseaudio:hover,
#custom-temperature:hover,
#memory:hover,
#cpu:hover,
#clock:hover,
#custom-lock:hover,
#custom-reboot:hover,
#custom-power:hover,
/*#workspaces:hover,*/
#window:hover {
  background-color: rgba(70, 75, 90, 0.9);
}

/* Workspace active state highlight */
#workspaces button:hover{
  background-color: rgba(97, 175, 239, 0.2);
  padding: 2px 8px;
  margin: 0 2px;
  border-radius: 10px;
}

#workspaces button.active {
  background-color: #61afef; /* Blue highlight */
  color: #ffffff;
  padding: 2px 8px;
  margin: 0 2px;
  border-radius: 10px;
}

/* Inactive workspace button */
#workspaces button {
  background: transparent;
  border: none;
  color: #888888;
  padding: 2px 8px;
  margin: 0 2px;
  font-weight: bold;
}

#window {
  font-weight: 500;
  font-style: italic;
}
      '';
    };
  };

  programs.waybar = {
  enable = true;
  settings = [
      layer: "top",
      position: "top",
      autohide: true,
      autohide-blocked: false,
      exclusive: true,
      passthrough: false,
      gtk-layer-shell: true,
      /* === Modules Order === */
      modules-left: [
        "custom/archicon",
        "clock",
        "cpu",
        "memory",
        "disk",
        "temperature"
      ],
      modules-center: [
        "hyprland/workspaces"
      ],
      modules-right: [
        "wlr/taskbar",
        "idle_inhibitor",
        "pulseaudio_slider",
        "pulseaudio",
        "network",
        "hyprland/language"
      ],
      /* === Modules Left === */
      "custom/nixicon": {
        format: "󱄅",
        on-click: "wofi --show drun",
        tooltip: false
      },
      clock: {
        timezone: "Africa/Johannesburg",
        format: "{:%I:%M  %d, %m}",
        tooltip-format: "{calendar}",
        calendar: {
          mode: "month"
        }
      },
      cpu: {
        format: "{usage}% ",
        tooltip: true,
        tooltip-format: "Uso de CPU: {usage}%\nNúcleos: {cores}"
      },
      memory: {
        format: "{}% 󰍛",
        tooltip: true,
        tooltip-format: "RAM en uso: {used} / {total} ({percentage}%)"
      },
      disk: {
        format: "{percentage_free}% ",
        tooltip: true,
        tooltip-format: "Espacio libre: {free} / {total} ({percentage_free}%)"
      },
      temperature: {
        format: "{temperatureC}°C {icon}",
        tooltip: true,
        tooltip-format: "Temperatura actual: {temperatureC}°C\nCritical si > 80°C",
        format-icons: [
          ""
        ]
      },
      /* === Modules Center === */
      "hyprland/workspaces": {
        format: "{icon}",
        format-icons: {
          default: "",
          active: ""
        },
        persistent-workspaces: {
          *: 2
        },
        disable-scroll: true,
        all-outputs: true,
        show-special: true
      },
      /* === Modules Right === */
      "wlr/taskbar": {
        format: "{icon}",
        all-outputs: true,
        active-first: true,
        tooltip-format: "{name}",
        on-click: "activate",
        on-click-middle: "close",
        ignore-list: [
          "rofi"
        ]
      },
      idle_inhibitor: {
        format: "{icon}",
        format-icons: {
          activated: "",
          deactivated: ""
        }
      },
      pulseaudio_slider: {
        format: "{volume}%",
        tooltip: false,
        on-click: "pavucontrol"
      },
      pulseaudio: {
        format: "{volume}% {icon}",
        format-muted: " {format_source}",
        format-icons: {
          default: [
            "",
            ""
          ]
        }
      },
      network: {
        format: "{ifname}",
        format-ethernet: "{ifname} 󰈀",
        format-disconnected: " ",
        tooltip-format: " {ifname} via {gwaddr}",
        tooltip-format-ethernet: " {ifname} {ipaddr}/{cidr}",
        tooltip-format-disconnected: "Disconnected",
        max-length: 50
      },
    ];
  };

}
