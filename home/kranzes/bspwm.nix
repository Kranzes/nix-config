{ config, pkgs, self, ... }:
{
  xsession = {
    enable = true;
    pointerCursor = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
    };
    windowManager.bspwm = {
      enable = true;
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
}
