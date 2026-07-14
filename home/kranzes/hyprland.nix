{ config, lib, ... }:

let
  inherit (lib.generators) mkLuaInline;
in
{
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  xdg.configFile."uwsm/env".source =
    "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    systemd.enable = false;
    configType = "lua";

    settings = {
      monitor = [
        {
          output = "";
          mode = "highres";
          position = "auto";
          scale = "auto";
        }
      ];

      config = {
        input = {
          kb_layout = "us,il";
          kb_options = "grp:lalt_lshift_toggle";
          accel_profile = "flat";
          follow_mouse = 2;
          touchpad.clickfinger_behavior = true;
        };

        general = {
          layout = "dwindle";
          gaps_in = 4;
          gaps_out = 8;
          border_size = 2;
          col = {
            active_border = mkLuaInline "colors.pink";
            inactive_border = mkLuaInline "colors.overlay0";
          };
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
        };
      };

      on._args = [
        "hyprland.start"
        (mkLuaInline ''
          function()
            hl.exec_cmd("noctalia-shell")
          end
        '')
      ];

      bind =
        lib.mapAttrsToList
          (k: d: {
            _args = [
              k
              (mkLuaInline d)
            ];
          })
          {
            "SUPER + Return" = ''hl.dsp.exec_cmd("alacritty")'';
            "SUPER + Space" = ''hl.dsp.exec_cmd("fuzzel")'';
            "SUPER + comma" = ''hl.dsp.exec_cmd("noctalia-shell ipc call settings toggle")'';
            "SUPER + W" = "hl.dsp.window.close()";
            "SUPER + SHIFT + W" = "hl.dsp.window.kill()";
            "SUPER + ALT + Q" = "hl.dsp.exit()";
            "ALT + 1" = ''hl.dsp.exec_cmd("firefox")'';
            "ALT + 2" = ''hl.dsp.exec_cmd("discord")'';
            "ALT + 3" = ''hl.dsp.exec_cmd("nemo")'';
            "ALT + 4" = ''hl.dsp.exec_cmd("alacritty -e ncmpcpp")'';
            "XF86AudioPlay" = ''hl.dsp.exec_cmd("noctalia-shell ipc call media playPause")'';
            "XF86AudioPrev" = ''hl.dsp.exec_cmd("noctalia-shell ipc call media previous")'';
            "XF86AudioNext" = ''hl.dsp.exec_cmd("noctalia-shell ipc call media next")'';
            "SUPER + H" = ''hl.dsp.focus({ direction = "left" })'';
            "SUPER + J" = ''hl.dsp.focus({ direction = "down" })'';
            "SUPER + K" = ''hl.dsp.focus({ direction = "up" })'';
            "SUPER + L" = ''hl.dsp.focus({ direction = "right" })'';
            "SUPER + SHIFT + H" = ''hl.dsp.window.swap({ direction = "left" })'';
            "SUPER + SHIFT + J" = ''hl.dsp.window.swap({ direction = "down" })'';
            "SUPER + SHIFT + K" = ''hl.dsp.window.swap({ direction = "up" })'';
            "SUPER + SHIFT + L" = ''hl.dsp.window.swap({ direction = "right" })'';
            "SUPER + C" = "hl.dsp.window.cycle_next()";
            "SUPER + SHIFT + C" = "hl.dsp.window.cycle_next({ next = false })";
            "SUPER + F" = ''hl.dsp.window.fullscreen({ mode = "fullscreen" })'';
            "SUPER + S" = ''hl.dsp.window.float({ action = "set" })'';
            "SUPER + T" = ''hl.dsp.window.float({ action = "unset" })'';
            "SUPER + V" = ''hl.dsp.layout("swapsplit")'';
            "SUPER + SHIFT + V" = ''hl.dsp.layout("togglesplit")'';
            "Print" = ''hl.dsp.exec_cmd("grim - | wl-copy && notify-send 'screenshot' 'captured'")'';
            "CTRL + Print" =
              ''hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy && notify-send 'screenshot' 'captured'")'';
            "SUPER + 1" = "hl.dsp.focus({ workspace = 1 })";
            "SUPER + 2" = "hl.dsp.focus({ workspace = 2 })";
            "SUPER + 3" = "hl.dsp.focus({ workspace = 3 })";
            "SUPER + 4" = "hl.dsp.focus({ workspace = 4 })";
            "SUPER + 5" = "hl.dsp.focus({ workspace = 5 })";
            "SUPER + 6" = "hl.dsp.focus({ workspace = 6 })";
            "SUPER + 7" = "hl.dsp.focus({ workspace = 7 })";
            "SUPER + 8" = "hl.dsp.focus({ workspace = 8 })";
            "SUPER + 9" = "hl.dsp.focus({ workspace = 9 })";
            "SUPER + 0" = "hl.dsp.focus({ workspace = 10 })";
            "SUPER + SHIFT + 1" = "hl.dsp.window.move({ workspace = 1, follow = false })";
            "SUPER + SHIFT + 2" = "hl.dsp.window.move({ workspace = 2, follow = false })";
            "SUPER + SHIFT + 3" = "hl.dsp.window.move({ workspace = 3, follow = false })";
            "SUPER + SHIFT + 4" = "hl.dsp.window.move({ workspace = 4, follow = false })";
            "SUPER + SHIFT + 5" = "hl.dsp.window.move({ workspace = 5, follow = false })";
            "SUPER + SHIFT + 6" = "hl.dsp.window.move({ workspace = 6, follow = false })";
            "SUPER + SHIFT + 7" = "hl.dsp.window.move({ workspace = 7, follow = false })";
            "SUPER + SHIFT + 8" = "hl.dsp.window.move({ workspace = 8, follow = false })";
            "SUPER + SHIFT + 9" = "hl.dsp.window.move({ workspace = 9, follow = false })";
            "SUPER + SHIFT + 0" = "hl.dsp.window.move({ workspace = 10, follow = false })";
          }
        ++ [
          {
            _args = [
              "XF86AudioRaiseVolume"
              (mkLuaInline ''hl.dsp.exec_cmd("noctalia-shell ipc call volume increase")'')
              {
                locked = true;
                repeating = true;
              }
            ];
          }
          {
            _args = [
              "XF86AudioLowerVolume"
              (mkLuaInline ''hl.dsp.exec_cmd("noctalia-shell ipc call volume decrease")'')
              {
                locked = true;
                repeating = true;
              }
            ];
          }
          {
            _args = [
              "XF86MonBrightnessUp"
              (mkLuaInline ''hl.dsp.exec_cmd("noctalia-shell ipc call brightness increase")'')
              {
                locked = true;
                repeating = true;
              }
            ];
          }
          {
            _args = [
              "XF86MonBrightnessDown"
              (mkLuaInline ''hl.dsp.exec_cmd("noctalia-shell ipc call brightness decrease")'')
              {
                locked = true;
                repeating = true;
              }
            ];
          }
          {
            _args = [
              "SUPER + ALT + H"
              (mkLuaInline "hl.dsp.window.resize({ x = -20, y = 0, relative = true })")
              { repeating = true; }
            ];
          }
          {
            _args = [
              "SUPER + ALT + J"
              (mkLuaInline "hl.dsp.window.resize({ x = 0, y = 20, relative = true })")
              { repeating = true; }
            ];
          }
          {
            _args = [
              "SUPER + ALT + K"
              (mkLuaInline "hl.dsp.window.resize({ x = 0, y = -20, relative = true })")
              { repeating = true; }
            ];
          }
          {
            _args = [
              "SUPER + ALT + L"
              (mkLuaInline "hl.dsp.window.resize({ x = 20, y = 0, relative = true })")
              { repeating = true; }
            ];
          }
          {
            _args = [
              "XF86AudioMute"
              (mkLuaInline ''hl.dsp.exec_cmd("noctalia-shell ipc call volume muteOutput")'')
              { locked = true; }
            ];
          }
          {
            _args = [
              "SUPER + mouse:272"
              (mkLuaInline "hl.dsp.window.drag()")
              { mouse = true; }
            ];
          }
          {
            _args = [
              "SUPER + mouse:273"
              (mkLuaInline "hl.dsp.window.resize()")
              { mouse = true; }
            ];
          }
        ];

      window_rule = [
        {
          match.class = "^(org\\.keepassxc\\.KeePassXC)$";
          no_screen_share = true;
        }
        {
          match.class = "^(gamescope)$";
          content = "game";
        }
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
