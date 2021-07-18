{ config, pkgs, ... }:
{

  xsession = {
    enable = true;
    windowManager.bspwm = {
      enable = true;
      startupPrograms = [
        "${pkgs.feh}/bin/feh --no-fehbg --bg-scale $HOME/Wallpapers/pexels-pok-rie.jpg"
        "pgrep bspswallow || bspswallow"
      ];
      settings = {
        remove_disabled_monitors = true;
        remove_unplugged_monitors = true;
        focused_border_color = "#88C0D0";
        border_width = 2;
        window_gap = 15;
      };
      monitors = { DP-0 = [ "I" "II" "III" "IV" "V" "VI" "VII" "VIII" "IX" "X" ]; };
      rules = {
        "Zathura" = {
          state = "tiled";
        };
      };
    };
  };

  # Needed for bspswallow to work.
  home.file.".config/bspwm/terminals".text = "Alacritty";
}

