{ pkgs, lib, ... }:

{
  home.pointerCursor = {
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
    x11.enable = true;
    gtk.enable = true;
  };

  xsession = {
    enable = true;
    windowManager.bspwm = {
      enable = true;
      monitors.primary = map toString (lib.range 1 10);
      settings = {
        remove_disabled_monitors = true;
        remove_unplugged_monitors = true;
        normal_border_color = "#6E738D";
        focused_border_color = "#f5bde6"; # catppuccin macchiato
        border_width = 2;
        window_gap = 15;
      };
      rules."Zathura".state = "tiled";
    };
  };
}
