{ config, lib, pkgs,... }:

let
  touchpad = ''
        touchpad {
          natural_scroll=true
          middle_button_emulation=true
          tap-to-click=false
        }
      }
      '';
  gestures = ''
      gestures {
        workspace_swipe=true
        workspace_swipe_fingers=3
        workspace_swipe_distance=100
      }
    '';
  workspaces = ''
      monitor=,preferred,auto,1
    '';
  wallpaper="$(cat $HOME/.cache/wal/wal)";
  execute = ''
    exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    exec-once=${pkgs.waybar}/bin/waybar
    exec-once=${pkgs.blueman}/bin/blueman-applet
      exec-once=${pkgs.swaybg}/bin/swaybg -m fill -i ${wallpaper} 
      exec-once=${pkgs.networkmanagerapplet}/bin/nm-applet --indicator
    '';
  terminal = "${pkgs.foot}/bin/foot";
  fileManager = "${pkgs.xfce.thunar}/bin/thunar";
  menuCommand = "${pkgs.wofi}/bin/wofi --show=drun -p 'Search'";
  lockCommand = "${pkgs.swaylock-effects}/bin/swaylock -f";
  logoutCommand = "${pkgs.wlogout}/bin/wlogout";
  screenshotFile = "~/Pictures/$(date +%Hh_%Mm_%Ss_%d_%B_%Y).png";
  screenshotCommand = ''${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.swappy}/bin/swappy -f - -o ${screenshotFile} && notify-send "Saved to ${screenshotFile}'';
  windowRules = ''
    windowrule=float,title:^(Volume Control)$
    windowrule=float,title:^(Picture-in-Picture)$
    windowrule=pin,title:^(Picture-in-Picture)$
    windowrule=move 75% 75% ,title:^(Picture-in-Picture)$
    windowrule=size 24% 24% ,title:^(Picture-in-Picture)$
    windowrule=opacity 0.93 override 0.8 override,Emacs
    windowrule=opacity 0.93 override 0.8 override,foot
  '';
  keybindings = ''
    bindm=SUPER,mouse:272,movewindow
    bindm=SUPER,mouse:273,resizewindow

    bindm=SUPER,Return,movewindow
    bind=SUPERSHIFT,Return,exec,${terminal}
    bind=SUPERSHIFT,C,killactive,
    bind=SUPERSHIFT,Q,exec,${logoutCommand}
    bind=SUPERSHIFT,Escape,exec,${lockCommand}
    bind=SUPERSHIFT,F,exec,${fileManager}
    bind=SUPER,T,togglefloating,
    bind=SUPER,P,exec,${menuCommand}
    bind=SUPERSHIFT,P,pseudo,
    bind=SUPER,F,fullscreen,
    bind=SUPER,R,forcerendererreload
    bind=SUPERSHIFT,R,exec,${pkgs.hyprland}/bin/hyprctl reload
    bind=SUPERSHIFT,E,exec,${pkgs.emacs}/bin/emacsclient -c

    bind=SUPER,left,movefocus,l
    bind=SUPER,right,movefocus,r
    bind=SUPER,up,movefocus,u
    bind=SUPER,down,movefocus,d

    bind=SUPER,H,movefocus,l
    bind=SUPER,L,movefocus,r
    bind=SUPER,K,movefocus,u
    bind=SUPER,J,movefocus,d

    bind=SUPERSHIFT,left,movewindow,l
    bind=SUPERSHIFT,right,movewindow,r
    bind=SUPERSHIFT,up,movewindow,u
    bind=SUPERSHIFT,down,movewindow,d

    bind=SUPERSHIFT,H,movewindow,l
    bind=SUPERSHIFT,L,movewindow,r
    bind=SUPERSHIFT,K,movewindow,u
    bind=SUPERSHIFT,J,movewindow,d

    bind=SUPER,1,workspace,1
    bind=SUPER,2,workspace,2
    bind=SUPER,3,workspace,3
    bind=SUPER,4,workspace,4
    bind=SUPER,5,workspace,5
    bind=SUPER,6,workspace,6
    bind=SUPER,7,workspace,7
    bind=SUPER,8,workspace,8
    bind=SUPER,9,workspace,9
    bind=SUPER,0,workspace,10

    bind=SUPERSHIFT,1,movetoworkspace,1
    bind=SUPERSHIFT,2,movetoworkspace,2
    bind=SUPERSHIFT,3,movetoworkspace,3
    bind=SUPERSHIFT,4,movetoworkspace,4
    bind=SUPERSHIFT,5,movetoworkspace,5
    bind=SUPERSHIFT,6,movetoworkspace,6
    bind=SUPERSHIFT,7,movetoworkspace,7
    bind=SUPERSHIFT,8,movetoworkspace,8
    bind=SUPERSHIFT,9,movetoworkspace,9
    bind=SUPERSHIFT,0,movetoworkspace,10

    bind=CTRL,right,resizeactive,20 0
    bind=CTRL,left,resizeactive,-20 0
    bind=CTRL,up,resizeactive,0 -20
    bind=CTRL,down,resizeactive,0 20

    bind=,print,exec,${screenshotCommand}"

    bind=,XF86AudioLowerVolume,exec,${pkgs.pamixer}/bin/pamixer -d 10
    bind=,XF86AudioRaiseVolume,exec,${pkgs.pamixer}/bin/pamixer -i 10
    bind=,XF86AudioMute,exec,${pkgs.pamixer}/bin/pamixer -t
    bind=,XF86AudioMicMute,exec,${pkgs.pamixer}/bin/pamixer --default-source -t
    bind=,XF86MonBrightnessDown,exec,${pkgs.light}/bin/light -U 5
    bind=,XF86MonBrightnessUP,exec,${pkgs.light}/bin/light -A 5
    '';
in
let
  hyprlandConf = ''
    ${workspaces}

    general {
      # main_mod=SUPER
      border_size=3
      gaps_in=5
      gaps_out=7
      col.active_border=0x80ffffff
      col.inactive_border=0x66333333
      layout=dwindle
    }

    decoration {
      rounding=5
      multisample_edges=true
      active_opacity=1
      inactive_opacity=0.93
      fullscreen_opacity=1
      blur=true
      drop_shadow=false
    }

    animations {
      enabled=true
      bezier = myBezier,0.1,0.7,0.1,1.05
      animation=fade,1,7,default
      animation=windows,1,7,myBezier
      animation=windowsOut,1,3,default,popin 60%
      animation=windowsMove,1,7,myBezier
    }

    input {
      kb_layout=us
      kb_options=caps:ctrl_modifier
      follow_mouse=1
      repeat_delay=250
      numlock_by_default=1
      accel_profile=flat
      sensitivity=0.8
      ${touchpad}
    }

    ${gestures}

    dwindle {
      pseudotile=false
      force_split=2
    }

    debug {
      damage_tracking=2
    }

    ${keybindings}

    ${windowRules}

    ${execute}
  '';
in
{
  xdg.configFile."hypr/hyprland.conf".text = hyprlandConf;

  home.packages = with pkgs; [
  ];

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
      { timeout= 600; command = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off"; resumeCommand = "${pkgs.hyprland}/bin/hyperctl dispatch dpms on";}
      { timeout= 1000; command = "systemctl suspend"; resumeCommand = "${pkgs.hyprland}/bin/hyperctl dispatch dpms on";}
    ];
    systemdTarget = "xdg-desktop-portal-hyprland.service";
  };
}
