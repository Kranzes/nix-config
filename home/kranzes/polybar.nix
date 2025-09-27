{ pkgs, config, ... }:

{
  services.polybar = {
    enable = true;
    package = pkgs.polybarFull;
    script = ''
      polybar centerbar &
      polybar leftbar &
      polybar rightbar &
    '';
    config = {
      "section/base" = {
        dpi = config.xresources.properties."Xft.dpi";
        height = "1.85%";
        offset-y = "0.65%";
        background = "\${colors.base}";
        foreground = "\${colors.text}";
        border-color = "\${colors.mauve}";
        border-size = 2;
        font-0 = "JetBrains Mono:size=9;2";
        font-1 = "Font Awesome 7 Free Solid:size=9;2";
        wm-restack = "bspwm";
      };
      "bar/leftbar" = {
        "inherit" = "section/base";
        modules-left = "bspwm";
        offset-x = "0.52%";
        width = if config.xresources.properties."Xft.dpi" == 144 then "12%" else "11.55%"; # TODO: just fucking use wayland
      };
      "module/bspwm" = {
        type = "internal/bspwm";
        label-active = "%index%";
        label-active-background = "\${colors.mauve}";
        label-active-foreground = "\${colors.base}";
        label-active-padding = 1;
        label-empty = "%index%";
        label-empty-padding = 1;
        label-occupied = "%index%";
        label-occupied-background = "\${colors.surface0}";
        label-occupied-padding = 1;
        label-urgent = "%index%";
        label-urgent-background = "\${colors.red}";
        label-urgent-foreground = "\${colors.base}";
        label-urgent-padding = 1;
      };
      "bar/centerbar" = {
        "inherit" = "section/base";
        modules-center = "mpd";
        offset-x = "40.89%";
        width = "18.23%";
      };
      "module/mpd".type = "internal/mpd";
      "bar/rightbar" = {
        "inherit" = "section/base";
        modules-right = "xkeyboard cpu memory pulseaudio date";
        offset-x = "84.74%";
        width = "14.74%";
      };
      "module/xkeyboard" = {
        type = "internal/xkeyboard";
        format-foreground = "\${colors.maroon}";
        format-padding = 1;
      };
      "module/cpu" = {
        type = "internal/cpu";
        format-foreground = "\${colors.green}";
        format-padding = 1;
        label = " %percentage%%";
      };
      "module/memory" = {
        type = "internal/memory";
        format-foreground = "\${colors.peach}";
        format-padding = 1;
        label = " %percentage_used%%";
      };
      "module/pulseaudio" = {
        type = "internal/pulseaudio";
        format-muted-background = "\${colors.red}";
        format-muted-foreground = "\${colors.base}";
        format-muted-padding = 1;
        format-volume = "<ramp-volume> <label-volume>";
        format-volume-foreground = "\${colors.sapphire}";
        format-volume-padding = 1;
        label-muted = "MUTED";
        ramp-volume-0 = "";
        ramp-volume-1 = "";
        ramp-volume-2 = "";
      };
      "module/date" = {
        type = "internal/date";
        date = "%d";
        date-alt = "%A";
        time = "%H:%M";
        format-foreground = "$\{colors.yellow}";
        format-padding = 1;
        label = "%date% %time%";
      };
    };
  };
}
