{ config, pkgs, ... }:
{

  xsession = {
    enable = true;
    windowManager.bspwm = {
      enable = true;
      startupPrograms = [
        "${pkgs.feh}/bin/feh --no-fehbg --bg-scale $HOME/Wallpapers/nord-lake.png"
        "pgrep bspswallow || bspswallow"
      ];
      settings = {
        remove_disabled_monitors = true;
        remove_unplugged_monitors = true;
        focused_border_color = "#88C0D0";
        border_width = 2;
        window_gap = 15;
      };
      monitors = { LVDS1 = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" ]; };
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
