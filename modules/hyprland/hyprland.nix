{
  config,
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      monitor = [
        "HDMI-A-1,preferred,auto,1"
        "eDP-1,3840x2400@60.00,auto-right,2"
        ",preferred,auto,1"
      ];

      windowrule = [
        # Spotify to special workspace
        "workspace special:magic, match:class ^(Spotify)$"
      ];

      exec-once = [
        "[workspace 1 silent] emacs"
        "[workspace 2 silent] firefox"
        "[workspace 3 silent] wezterm"
        "waybar &"
        "~/nixweo/resources/hyprland_scripts/launch_spotify.sh"
        "sleep 1 && hyprctl dispatch workspace 2"
      ];

      workspace = [
        "1, monitor:HDMI-A-1"
        "2, monitor:HDMI-A-1"
        "3, monitor:HDMI-A-1"
        "4, monitor:HDMI-A-1"
        "5, monitor:HDMI-A-1"

        "6, monitor:eDP-1"
        "7, monitor:eDP-1"
        "8, monitor:eDP-1"
        "9, monitor:eDP-1"
        "10, monitor:eDP-1"
      ];

      "$mod" = "SUPER";
      "$terminal" = "wezterm";
      "$fileManager" = "nautilus";
      "$emacs" = "emacs";
      "$browser" = "firefox";
      "$suspend" = "systemctl suspend";

      general.gaps_in = 2;
      general.gaps_out = 4;
      general.border_size = 1;
      general.resize_on_border = false;
      general.allow_tearing = false;
      general.layout = "dwindle";

      decoration.rounding = 7;
      decoration.active_opacity = 1.0;
      decoration.inactive_opacity = 0.6;
      decoration.blur = {
        enabled = true;
        size = 3;
        passes = 3;
        vibrancy = 0.1696;
      };

      animations = {
        enabled = true;
        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];

        animation = [
          "global,1,10,default"
          "border,1,5.39,easeOutQuint"
          "windows,1,4.79,easeOutQuint"
          "windowsIn,1,4.1,easeOutQuint,popin 87%"
          "windowsOut,1,1.49,linear,popin 87%"
          "fadeIn,1,1.73,almostLinear"
          "fadeOut,1,1.46,almostLinear"
          "fade,1,3.03,quick"
          "layers,1,3.81,easeOutQuint"
          "layersIn,1,4,easeOutQuint,fade"
          "layersOut,1,1.5,linear,fade"
          "fadeLayersIn,1,1.79,almostLinear"
          "fadeLayersOut,1,1.39,almostLinear"
          "workspaces,1,1.94,almostLinear,fade"
          "workspacesIn,1,1.21,almostLinear,fade"
          "workspacesOut,1,1.94,almostLinear,fade"
        ];
      };

      cursor.no_hardware_cursors = true;
      dwindle.pseudotile = true;
      dwindle.preserve_split = true;
      master.new_status = "master";
      gesture = [
        # Three-finger horizontal swipe to switch workspaces
        "3, horizontal, workspace, e+1"
      ];
      binds.allow_workspace_cycles = true;

      bind =
        [
          "$mod, Return, exec, $terminal"
          "$mod, D, exec, $fileManager"
          "$mod, Space, exec, rofi -show run"
          "$mod, E, exec, $emacs"
          "$mod, F, exec, $browser"
          "$mod, B, exec, pkill -SIGUSR1 waybar"

          "$mod SHIFT, Q, killactive"
          "$mod, Escape, exec, $suspend"
          "$mod CTRL, F, togglefloating"
          "$mod CTRL, P, pseudo"
          "$mod CTRL, S, togglesplit"
          "$mod SHIFT, M, fullscreen"

          # Mac-style copy/paste
          "$mod, C, sendshortcut, CTRL, SHIFT"
          "$mod SHIFT, C, sendshortcut, CTRL, SHIFT"
          "$mod, V, sendshortcut, CTRL, SHIFT"
          "$mod, Z, sendshortcut, CTRL"
          "$mod, X, sendshortcut, CTRL"

          "$mod, h, movefocus, l"
          "$mod, l, movefocus, r"
          "$mod, k, movefocus, u"
          "$mod, j, movefocus, d"

          "$mod SHIFT, J, workspace, +1"
          "$mod SHIFT, K, workspace, -1"
          "$mod, Tab, workspace, previous"

          "$mod, S, togglespecialworkspace, magic"
          "$mod SHIFT, S, movetoworkspace, special:magic"

          "$mod CTRL, J, workspace, e+1"
          "$mod CTRL, K, workspace, e-1"
          "$mod, 0, workspace, 10"
          "$mod SHIFT, 0, movetoworkspace, 10"

          "$mod, COMMA, focusmonitor, +1"
          "$mod SHIFT, COMMA, focusmonitor, -1"

          "$mod, F5, exec, hyprshot -m region"
          "$mod SHIFT, F5, exec, hyprshot -m window"
          "$mod CTRL, F5, exec, hyprshot -m output"

          ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
          ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_SINK@ 5%-"
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_SINK@ toggle"
        ]
        ++ (builtins.concatLists (
          builtins.genList (
            i: let
              ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          9
        ));

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };

  # Example extra programs
  programs.kitty.enable = true;

  # Environment variables for Wayland/Electron
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    HYPRCURSOR_THEME = "Bibata-Modern-Ice";
    HYPRCURSOR_SIZE = "24";
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NVD_BACKEND = "direct";
    YDOTOOL_SOCKET = "/run/ydotool/socket"; # Add this
  };
}
