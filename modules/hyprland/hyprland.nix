{ config, pkgs, lib, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      monitor = [
        "HDMI-A-1,3440x1440@49.99,0x0,1"
        "eDP-1,3840x2400@60.00,3440x0,2"
        ",preferred,auto,1"
      ];
      
      exec-once = [
        "emacs"
        "pipewire &"
        "wireplumber &"
        "waybar &"
      ];

      "$mod" = "SUPER";
      "$terminal" = "wezterm";
      "$fileManager" = "nautilus";
      "$emacs" = "emacs";
      "$browser" = "firefox";

      general.gaps_in = 5;
      general.gaps_out = 6;
      general.border_size = 1;
      general.resize_on_border = false;
      general.allow_tearing = false;
      general.layout = "dwindle";

      decoration.rounding = 20;
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
      gestures.workspace_swipe = true;
      binds.allow_workspace_cycles = true;
      
      bind =
        [
          "$mod, Return, exec, $terminal"
          "$mod, D, exec, $fileManager"
          "$mod, Space, exec, rofi -show run"
          "$mod, E, exec, $emacs"
          "$mod, F, exec, $browser"

          "$mod SHIFT, Q, killactive"
          "$mod, Escape, exit"
          "$mod CTRL, F, togglefloating"
          "$mod CTRL, P, pseudo"
          "$mod CTRL, S, togglesplit"
          "$mod SHIFT, M, fullscreen"

          "$mod, B, exec, pkill -SIGUSR1 waybar"

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

          "$mod, F5, exec, hyprshot -m region"
          "$mod SHIFT, F5, exec, hyprshot -m window"
          "$mod CTRL, F5, exec, hyprshot -m output"
        ]
        ++ (
          builtins.concatLists (builtins.genList (i:
              let ws = i + 1;
              in [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            )
            9)
        );
    };
  };

  # Example extra programs
  programs.kitty.enable = true;

  # Environment variables for Wayland/Electron
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XCURSOR_SIZE = "60";
    HYPRCURSOR_SIZE = "60";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NVD_BACKEND = "direct";
  };
}
