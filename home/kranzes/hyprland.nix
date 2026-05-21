{ config, lib, ... }:

{
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  xdg.configFile."uwsm/env".source =
    "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    systemd.enable = false;

    settings = {
      monitor = lib.mkDefault ",highres,auto,auto";

      input = {
        kb_layout = "us,il";
        kb_options = "grp:lalt_lshift_toggle";
        accel_profile = "flat";
        follow_mouse = 2;
        touchpad.clickfinger_behavior = true;
      };

      device = [
        {
          # Keep mouse accel for Framework touchpad.
          name = "pixa3854:00-093a:0274-touchpad";
          accel_profile = "adaptive";
        }
      ];

      general = {
        layout = "dwindle";
        gaps_in = 4;
        gaps_out = 8;
        border_size = 2;
        "col.active_border" = "$pink";
        "col.inactive_border" = "$overlay0";
        allow_tearing = true;
      };

      dwindle = {
        force_split = 2;
        preserve_split = true;
      };

      decoration = {
        blur.enabled = false;
        shadow.enabled = false;
        rounding = 10;
      };
      animations.enabled = false;

      render.direct_scanout = 2;

      cursor.no_warps = true;

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        middle_click_paste = false;
        vrr = 1;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        force_default_wallpaper = 0;
        focus_on_activate = true;
        enable_swallow = true;
        swallow_regex = "Alacritty";
      };

      exec-once = [
        "noctalia-shell"
      ];

      "$mod" = "SUPER";
      "$nocCall" = "noctalia-shell ipc call";
      bind = [
        "$mod, Return, exec, alacritty"
        "$mod, Space, exec, fuzzel"
        "$mod, comma, exec, $nocCall settings toggle"
        "$mod, W, killactive,"
        "$mod ALT, Q, exit,"

        "ALT, 1, exec, firefox"
        "ALT, 2, exec, discord"
        "ALT, 3, exec, nemo"
        "ALT, 4, exec, alacritty -e ncmpcpp"

        ", XF86AudioPlay, exec, $nocCall media playPause"
        ", XF86AudioPrev, exec, $nocCall media previous"
        ", XF86AudioNext, exec, $nocCall media next"

        "$mod, H, movefocus, l"
        "$mod, J, movefocus, d"
        "$mod, K, movefocus, u"
        "$mod, L, movefocus, r"

        "$mod SHIFT, H, swapwindow, l"
        "$mod SHIFT, J, swapwindow, d"
        "$mod SHIFT, K, swapwindow, u"
        "$mod SHIFT, L, swapwindow, r"

        "$mod, C, cyclenext,"
        "$mod SHIFT, C, cyclenext, prev"

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        "$mod SHIFT, 1, movetoworkspacesilent, 1"
        "$mod SHIFT, 2, movetoworkspacesilent, 2"
        "$mod SHIFT, 3, movetoworkspacesilent, 3"
        "$mod SHIFT, 4, movetoworkspacesilent, 4"
        "$mod SHIFT, 5, movetoworkspacesilent, 5"
        "$mod SHIFT, 6, movetoworkspacesilent, 6"
        "$mod SHIFT, 7, movetoworkspacesilent, 7"
        "$mod SHIFT, 8, movetoworkspacesilent, 8"
        "$mod SHIFT, 9, movetoworkspacesilent, 9"
        "$mod SHIFT, 0, movetoworkspacesilent, 10"

        "$mod, F, fullscreen, 0"
        "$mod, M, fullscreen, 1"
        "$mod, S, setfloating,"
        "$mod, T, settiled,"

        "$mod, V, layoutmsg, togglesplit"
        "$mod SHIFT, V, layoutmsg, swapsplit"

        ", Print, exec, grim - | wl-copy && notify-send 'screenshot' 'captured'"
        "CTRL, Print, exec, grim -g \"$(slurp)\" - | wl-copy && notify-send 'screenshot' 'captured'"
      ];

      bindel = [
        ", XF86AudioRaiseVolume, exec, $nocCall volume increase"
        ", XF86AudioLowerVolume, exec, $nocCall volume decrease"
        ", XF86MonBrightnessUp, exec, $nocCall brightness increase"
        ", XF86MonBrightnessDown, exec, $nocCall brightness decrease"
      ];

      binde = [
        "$mod ALT, H, resizeactive, -20 0"
        "$mod ALT, J, resizeactive, 0 20"
        "$mod ALT, K, resizeactive, 0 -20"
        "$mod ALT, L, resizeactive, 20 0"
      ];

      bindl = [
        ", XF86AudioMute, exec, $nocCall volume muteOutput"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      windowrule = [
        "no_screen_share on, match:class ^(org\\.keepassxc\\.KeePassXC)$"
        "content game, match:class ^(gamescope)$"
      ];
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      animations.enabled = false;
      auth.fingerprint.enabled = true;
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 900;
          on-timeout = "loginctl lock-session";
        }
      ];
    };
  };
}
