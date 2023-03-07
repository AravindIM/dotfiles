#
# Bar
#

{ config, lib, pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    waybar
  ];

  nixpkgs.overlays = [                                      # Waybar needs to be compiled with the experimental flag for wlr/workspaces to work
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
        patchPhase = ''
          substituteInPlace src/modules/wlr/workspace_manager.cpp --replace "zext_workspace_handle_v1_activate(workspace_handle_);" "const std::string command = \"hyprctl dispatch workspace \" + name_; system(command.c_str());"
        '';
      });
    })
  ];

  home-manager.users.aim = {                           # Home-manager waybar config
    programs.waybar = {
      enable = true;
      systemd ={
        enable = true;
        target = "sway-session.target";                     # Needed for waybar to start automatically
      };

      style = ''
        @import url("file:///home/aim/.cache/wal/color-scheme.css");
        *
         {
            border: none;
            border-radius: 6px;
            font-family: FontAwesome, Roboto Bold, Helvetica, Arial, sans-serif;
            font-size: 16px;
        }

        window#waybar {
            background: shade(alpha(@background, 0.4), 1.0);
            border-bottom: shade(alpha(@color1, 0.9), 1.0);
            color: @foreground;
            transition-property: background-color;
            transition-duration: .5s;
        }

        window#waybar.hidden {
            opacity: 0.2;
        }

        /*
        window#waybar.empty {
            background-color: transparent;
        }
        window#waybar.solo {
            background-color: #FFFFFF;
        }
        */

        #workspaces button {
            padding: 0 5px;
            background-color: transparent;
            color: @foreground;
            /* Use box-shadow instead of border so the text isn't offset */
            box-shadow: inset 0 -3px transparent;
            /* Avoid rounded borders under each workspace name */
            border: none;
        }

        #workspaces button:hover {
            background: rgba(0, 0, 0, 0.2);
            box-shadow: inset 0 -3px @color5;
            border: none;

        }

        #workspaces button.focused {
            background-color: @color2;
            box-shadow: inset 0 -3px @color3;
            border: none;
        }

        #workspaces button.active {
            background-color: @color2;
            box-shadow: inset 0 -3px @color3;
            border: none;
        }

        #workspaces button.urgent {
            background-color: shade(alpha(#f53c3c, 0.7), 0.8);
        }

        #mode {
            background-color: #64727D;
            border-bottom: 3px solid #ffffff;
        }

        #clock,
        #battery,
        #cpu,
        #memory,
        #disk,
        #temperature,
        #backlight,
        #network,
        #pulseaudio,
        #custom-media,
        #tray,
        #mode,
        #idle_inhibitor,
        #mpd
        #gamemode
         {
            padding: 0 10px;
            color: @background;
        }

        #cpu,
        #network,
        #temperature,
        #battery,
        #tray {
            background-color: @color5;
        }

        #pulseaudio,
        #memory,
        #backlight,
        #language,
        #keyboard-state,
        #clock {
            background-color: @color15;
        }

        #battery.charging, #battery.plugged {
            color: @foreground;
            background-color: #26A65B;
        }

        @keyframes blink {
            to {
                background-color: @foreground;
                color: @background;
            }
        }

        #battery.critical:not(.charging) {
            background-color: #f53c3c;
            color: @foreground;
            animation-name: blink;
            animation-duration: 0.5s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
        }

        label:focus {
            background-color: @background;
        }

        #disk {
            background-color: #964B00;
        }

        #network.disconnected {
            background-color: #f53c3c;
        }

        #pulseaudio.muted {
            background-color: #f53c3c;
        }

        #temperature.critical {
            background-color: #ed8796;
        }

        #tray > .passive {
            -gtk-icon-effect: dim;
        }

        #tray > .needs-attention {
            -gtk-icon-effect: highlight;
            background-color: #8aadf4;
        }

        #idle_inhibitor {
            background-color: @background;
            color: @foreground;
        }

        #idle_inhibitor.activated {
            background-color: @foreground;
            color: @background;
        }

        #language {
            color: #4c4f69;
            padding: 0 5px;
            margin: 0 5px;
            min-width: 16px;
        }


        #keyboard-state {
            color: #4c4f69;
            padding: 0 0px;
            margin: 0 5px;
            min-width: 16px;
        }

        #keyboard-state > label {
            padding: 0 5px;
        }

        #keyboard-state > label.locked {
            background: rgba(0, 0, 0, 0.2);
        }

        #custom-power {
            background-color: #f53c3c;
            color: @foreground;
            padding: 0 15px;

        }
      '';
      settings = {
        Main = {
          layer = "top";
          position = "top";
          height = 35;
          spacing = 4;
          tray = { spacing = 5; };
          #modules-center = [ "clock" ];
          modules-left = with config;
            if programs.hyprland.enable == true then
              [ "wlr/workspaces" "hyprland/window"]
            else if programs.sway.enable == true then
              [ "sway/workspaces" "sway/window" "sway/mode" ]
            else [];
  
          modules-right = [ "idle_inhibitor" "pulseaudio" "cpu" "memory" "temperature" "backlight" "battery" "clock" "tray" "custom/power"];
  
          "sway/workspaces" = {
            format = "<span font='12'>{icon}</span>";
            persistent_workspaces = {
               "1" = [];
               "2" = [];
               "3" = [];
               "4" = [];
               "5" = [];
               "6" = [];
               "7" = [];
               "8" = [];
               "9" = [];
            };
          };
          "wlr/workspaces" = {
            format = "<span font='11'>{name}</span>";
            persistent_workspaces = {
               "1" = [];
               "2" = [];
               "3" = [];
               "4" = [];
               "5" = [];
               "6" = [];
               "7" = [];
               "8" = [];
               "9" = [];
            };
            #format = "<span font='12'>{icon}</span>";
            #format-icons = {
            #  "1"="";
            #  "2"="";
            #  "3"="";
            #  "4"="";
            #  "5"="";
            #  "6"="";
            #  "7"="";
            #  "8"="";
            #  "9"="";
            #  "10"="";
            #};
            #all-outputs = true;
            active-only = false;
            on-click = "activate";
          };
          idle_inhibitor = {
            format = "<span font='11'>{icon}</span>";
            format-icons = {
              activated = "";
              deactivated = "";
            };
          };
          clock = {
            format = "{:%b %d %H:%M}  ";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            #format-alt = "{:%A, %B %d, %Y} ";
          };
          cpu = {
            format = " {usage}% <span font='11'></span> ";
            interval = 1;
          };
          disk = {
            format = "{percentage_used}% <span font='11'></span>";
            path = "/";
            interval = 30;
          };
          memory = {
            format = "{}% <span font='11'></span>";
            interval = 1;
          };
          backlight = {
            device = "intel_backlight";
            format= "{percent}% <span font='11'>{icon}</span>";
            format-icons = ["" ""];
            on-scroll-down = "${pkgs.light}/bin/light -U 5";
            on-scroll-up = "${pkgs.light}/bin/light -A 5";
          };
          battery = {
            bat = "BAT0";
            interval = 60;
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{capacity}% <span font='11'>{icon}</span>";
            format-charging = "{capacity}% <span font='11'></span>";
            format-icons = ["" "" "" "" ""];
            max-length = 25;
          };
          network = {
            format-wifi = "<span font='11'></span>";
            format-ethernet = "<span font='11'></span>";
            #format-ethernet = "<span font='11'></span> {ifname}: {ipaddr}/{cidr}";
            format-linked = "<span font='11'>睊</span> {ifname} (No IP)";
            format-disconnected = "<span font='11'>睊</span> Not connected";
            #format-alt = "{ifname}: {ipaddr}/{cidr}";
            tooltip-format = "{essid} {ipaddr}/{cidr}";
            #on-click-right = "${pkgs.alacritty}/bin/alacritty -e nmtui";
          };
          pulseaudio = {
            format = "<span font='11'>{icon}</span> {volume}% {format_source} ";
            format-bluetooth = "<span font='11'>{icon}</span> {volume}% {format_source} ";
            format-bluetooth-muted = "<span font='11'>x</span> {volume}% {format_source} ";
            format-muted = "<span font='11'>x</span> {format_source} ";
            #format-source = "{volume}% <span font='11'></span>";
            format-source = "<span font='10'></span> ";
            format-source-muted = "<span font='11'> </span> ";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = ["" "" ""];
            };
            tooltip-format = "{desc}, {volume}%";
            on-click = "${pkgs.pamixer}/bin/pamixer -t";
            on-click-right = "${pkgs.pamixer}/bin/pamixer --default-source -t";
            on-click-middle = "${pkgs.pavucontrol}/bin/pavucontrol";
          };
          temperature = {
            # thermal-zone= 2;
            # hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
            critical-threshold = 80;
            # format-critical = "{temperatureC}°C {icon}";
            format = "{temperatureC}°C <span font='11'>{icon}</span>";
            format-icons = ["" "" ""];
          };
          tray = {
            icon-size = 13;
          };
          "custom/power" = {
            format = "";
            on-click= "exec wlogout";
            tooltip = false;
          };
        };
      };
    };
  };
}
