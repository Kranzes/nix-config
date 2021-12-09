{ config, pkgs, ... }:
{
  xsession = {
    enable = true;
    windowManager.bspwm = {
      enable = true;
      startupPrograms = [
        "pgrep ${pkgs.bspswallow}/bin/bspswallow || ${pkgs.bspswallow}/bin/bspswallow"
      ];
      settings = {
        remove_disabled_monitors = true;
        remove_unplugged_monitors = true;
        focused_border_color = "#${config.colorscheme.colors.base0C}";
        border_width = 2;
        window_gap = 15;
      };
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
