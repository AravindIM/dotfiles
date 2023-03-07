{ config, pkgs, ...}:
let
  theme = {
    background = "#000000";
    foreground = "#ffffff";
  
    black = "#000000";
    red = "#ff8059";
    green = "#44bc44";
    yellow = "#d0bc00";
    blue = "#2fafff";
    magenta = "#feacd0";
    cyan = "#00d3d0";
    white = "#bfbfbf";
  
    bright-black = "#595959";
    bright-red = "#ef8b50";
    bright-green = "#70b900";
    bright-yellow = "#c0c530";
    bright-blue = "#79a8ff";
    bright-magenta = "#b6a0ff";
    bright-cyan = "#6ae4b9";
    bright-white = "#ffffff";
  };
  wallpaper="$(cat $HOME/.cache/wal/wal)";
  lockCommand = "${pkgs.swaylock-effects}/bin/swaylock -f";
  screenshotFile = "~/Pictures/$(date +%Hh_%Mm_%Ss_%d_%B_%Y).png";
  screenshotCommand = ''${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.swappy}/bin/swappy -f - -o ${screenshotFile} && notify-send "Saved to ${screenshotFile}'';
in
{
  wayland.windowManager.sway = let
    gsettings = "${pkgs.glib}/bin/gsettings";
    gnomeSchema = "org.gnome.desktop.interface";
    importGsettings = pkgs.writeShellScript "import_gsettings.sh" ''
      config="/home/alternateved/.config/gtk-3.0/settings.ini"
      if [ ! -f "$config" ]; then exit 1; fi
      gtk_theme="$(grep 'gtk-theme-name' "$config" | sed 's/.*\s*=\s*//')"
      icon_theme="$(grep 'gtk-icon-theme-name' "$config" | sed 's/.*\s*=\s*//')"
      cursor_theme="$(grep 'gtk-cursor-theme-name' "$config" | sed 's/.*\s*=\s*//')"
      font_name="$(grep 'gtk-font-name' "$config" | sed 's/.*\s*=\s*//')"
      ${gsettings} set ${gnomeSchema} gtk-theme "$gtk_theme"
      ${gsettings} set ${gnomeSchema} icon-theme "$icon_theme"
      ${gsettings} set ${gnomeSchema} cursor-theme "$cursor_theme"
      ${gsettings} set ${gnomeSchema} font-name "$font_name"
    '';
  in
  {
    enable = true;
    xwayland = true;
    systemdIntegration = true;
    wrapperFeatures = {
      base = true;
      gtk = true;
    };

    config = rec {
      modifier = "Mod4";

      input = {
        "type:touchpad" = {
          # tap = "enabled";
          dwt = "enabled";
          scroll_method = "two_finger";
          middle_emulation = "enabled";
          natural_scroll = "enabled";
        };
        "type:pointer" = {
          natural_scroll = "enabled";
        };
        "type:keyboard" = {
          xkb_layout = "us";
        };
      };

      output = {
        "*".bg = "${wallpaper} fill";
        "*".scale = "1";
      };

      # fonts = {
      #   names = [ "Rec Mono Casual" ];
      #   size = 10.5;
      # };

      focus = { followMouse = "always"; };

      gaps = {
        inner = 5;
        outer = 5;
        smartGaps = true;
        smartBorders = "on";
      };

      window = {
        border = 2;
        titlebar = false;
        commands = [
          {
            criteria = { title = "^(.*) Indicator"; };
            command = "floating enable";
          }
          {
            criteria = { class = "Emacs"; };
            command = "opacity 0.9";
          }
        ];
      };

      startup = [
        { command = "${importGsettings}"; }
        { command = "${pkgs.xorg.xrdb}/bin/xrdb -merge ~/.Xresources"; }
      ];


      colors = rec {
        background = theme.background;
        unfocused = {
          text = theme.foreground;
          border = theme.foreground;
          background = theme.background;
          childBorder = theme.background;
          indicator = theme.foreground;
        };
        focusedInactive = unfocused;
        urgent = unfocused // {
          text = theme.foreground;
          border = theme.red;
          childBorder = theme.red;
        };
        focused = unfocused // {
          childBorder = theme.foreground;
          border = theme.foreground;
          background = theme.foreground;
          text = theme.background;
        };
      };

      bars = [{
       command = "waybar";
      }];

      modes = {
        resize = {
          h = "resize shrink width 10 px or 10 ppt";
          l = "resize grow width 10 px or 10 ppt";
          k = "resize shrink height 10 px or 10 ppt";
          j = "resize grow height 10 px or 10 ppt";
          Left = "resize shrink width 10 px or 10 ppt";
          Right = "resize grow width 10 px or 10 ppt";
          Up = "resize shrink height 10 px or 10 ppt";
          Down = "resize grow height 10 px or 10 ppt";
          Return = "mode default";
          Escape = "mode default";
        };
      };

      terminal = "${pkgs.foot}/bin/foot";
      menu = "${pkgs.wofi}/bin/wofi --show=drun -p 'Search'";

      keybindings = {
        "${modifier}+Shift+Return" = "exec ${terminal}";
        "${modifier}+Shift+c" = "kill";
        "${modifier}+Shift+r" = "reload";

        "${modifier}+p" = "exec ${menu}";

        "${modifier}+Left" = "focus left";
        "${modifier}+Down" = "focus down";
        "${modifier}+Up" = "focus up";
        "${modifier}+Right" = "focus right";

        "${modifier}+Shift+Left" = "move left";
        "${modifier}+Shift+Down" = "move down";
        "${modifier}+Shift+Up" = "move up";
        "${modifier}+Shift+Right" = "move right";

        "${modifier}+Control+Left" = "resize shrink width 20 px";
        "${modifier}+Control+Down" = "resize grow height 20 px";
        "${modifier}+Control+Up" = "resize shrink height 20 px";
        "${modifier}+Control+Right" = "resize grow width 20 px";

        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "focus up";
        "${modifier}+l" = "focus right";

        "${modifier}+Shift+h" = "move left";
        "${modifier}+Shift+j" = "move down";
        "${modifier}+Shift+k" = "move up";
        "${modifier}+Shift+l" = "move right";

        "${modifier}+Control+h" = "resize shrink width 20 px";
        "${modifier}+Control+j" = "resize grow height 20 px";
        "${modifier}+Control+k" = "resize shrink height 20 px";
        "${modifier}+Control+l" = "resize grow width 20 px";

        "${modifier}+Shift+Tab" = "workspace prev";
        "${modifier}+Tab" = "workspace next";

        "${modifier}+b" = "split v";
        "${modifier}+v" = "split h";

        "${modifier}+Shift+f" = "fullscreen toggle";

        "${modifier}+a" = "focus parent";
        "${modifier}+d" = "focus child";
        "${modifier}+Shift+n" = "focus next";
        "${modifier}+Shift+p" = "focus prev";

        "${modifier}+q" = "layout stacking";
        "${modifier}+t" = "layout tabbed";
        "${modifier}+s" = "layout toggle split";

        "${modifier}+f" = "floating toggle";
        "${modifier}+Control+s" = "sticky toggle";
        "${modifier}+space" = "focus mode_toggle";

        "${modifier}+Shift+b" = "bar mode toggle";

        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";

        "${modifier}+Shift+1" = "move container to workspace number 1";
        "${modifier}+Shift+2" = "move container to workspace number 2";
        "${modifier}+Shift+3" = "move container to workspace number 3";
        "${modifier}+Shift+4" = "move container to workspace number 4";
        "${modifier}+Shift+5" = "move container to workspace number 5";
        "${modifier}+Shift+6" = "move container to workspace number 6";
        "${modifier}+Shift+7" = "move container to workspace number 7";
        "${modifier}+Shift+8" = "move container to workspace number 8";
        "${modifier}+Shift+9" = "move container to workspace number 9";

        "${modifier}+grave" = "workspace back_and_forth";

        "${modifier}+Shift+z" = "mark z; move scratchpad";
        "${modifier}+z" = "[con_mark=z] scratchpad show";
        "${modifier}+Shift+s" = "mode scratchpad";
        "${modifier}+r" = "mode resize";
        "${modifier}+y" = "mode workspace";

        "${modifier}+Shift+e" = "exec ${pkgs.emacs}/bin/emacsclient -a '' -c";
        "${modifier}+Shift+b" = "exec ${pkgs.firefox}/bin/firefox";

        "${modifier}+Shift+q" = "exec ${pkgs.wlogout}/bin/wlogout";
        "${modifier}+F1" =
          "exec echo $(${pkgs.sxiv}/bin/sxiv -t -o ~/Pictures/Wallpapers) | xargs ${pkgs.pywal}/bin/wal -i";

        "Print" = "exec ${screenshotCommand}";
        "Control+Shift+space" = "exec makoctl dismiss -a";
        "Control+Shift+comma" = "exec makoctl restore";

        "XF86AudioLowerVolume" = "exec ${pkgs.pamixer}/bin/pamixer -d 10";
        "XF86AudioLowerVolume+Shift" =
          "exec ${pkgs.pamixer}/bin/pamixer -d 10 --allow-boost";
        "XF86AudioRaiseVolume" = "exec ${pkgs.pamixer}/bin/pamixer -i 10";
        "XF86AudioRaiseVolume+Shift" =
          "exec ${pkgs.pamixer}/bin/pamixer -i 10 --allow-boost";
        "XF86AudioMute" = "exec ${pkgs.pamixer}/bin/pamixer -t";

        "XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U 5";
        "XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 5";
      };
    };
  };
  programs.swaylock.settings = {
    image = "${wallpaper}";
    color = "000000f0";
    font-size = "24";
    clock = true;
    effect-blur = "12x4";
    ignore-empty-password = true;
    indicator-idle-visible = true;
    indicator-caps-lock = true;
    indicator-radius = 100;
    indicator-thickness = 20;
    inside-color = "00000000";
    inside-clear-color = "00000000";
    inside-ver-color = "00000000";
    inside-wrong-color = "00000000";
    key-hl-color = "79b360";
    line-color = "000000f0";
    line-clear-color = "000000f0";
    line-ver-color = "000000f0";
    line-wrong-color = "000000f0";
    ring-color = "ffffff50";
    ring-clear-color = "bbbbbb50";
    ring-ver-color = "bbbbbb50";
    ring-wrong-color = "b3606050";
    text-color = "ffffff";
    text-ver-color = "ffffff";
    text-wrong-color = "ffffff";
    show-failed-attempts = true;
  };
  services.swayidle = {
    enable = true;
    events = [
      { event = "before-sleep"; command = "${lockCommand}"; }
      { event = "lock"; command = "${lockCommand}"; }
    ];
    timeouts = [
      { timeout= 300; command = "${lockCommand}";}
      { timeout= 600; command = "${pkgs.sway}/bin/swaymsg 'output * dpms off'"; resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * dpms on'";}
      { timeout= 1000; command = "systemctl suspend"; resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * dpms on'";}
    ];
    systemdTarget = "xdg-desktop-portal-sway.service";
  };

}

