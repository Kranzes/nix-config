{ config, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    package = pkgs.alacritty;
    settings = {
      font = {
        normal = {
          family = "JetBrains Mono";
          style = "Regular";
        };
        bold = {
          family = "JetBrains Mono";
          style = "Bold";
        };
        italic = {
          family = "JetBrains Mono";
          style = "Italic";
        };
        bold_italic = {
          family = "JetBrains Mono";
          style = "Bold Italic";
        };
        size = 8;
      };
      colors = let inherit (config.colorscheme) colors; in
        {
          primary = {
            background = "#${colors.base00}";
            foreground = "#${colors.base04}";
          };
          cursor = {
            text = "#${colors.base00}";
            cursor = "#${colors.base04}";
          };
          vi_mode_cursor = {
            text = "#${colors.base00}";
            cursor = "#${colors.base04}";
          };
          selection = {
            text = "CellForeground";
            background = "#${colors.base03}";
          };
          search = {
            matches = {
              foreground = "CellBackground";
              background = "#${colors.base0C}";
            };
            bar = {
              background = "#${colors.base02}";
              foreground = "#${colors.base04}";
            };
          };
          normal = {
            black = "#${colors.base01}";
            red = "#${colors.base08}";
            green = "#${colors.base0B}";
            yellow = "#${colors.base0A}";
            blue = "#${colors.base0D}";
            magenta = "#${colors.base0E}";
            cyan = "#${colors.base0C}";
            white = "#${colors.base05}";
          };
          bright = {
            black = "#${colors.base03}";
            red = "#${colors.base08}";
            green = "#${colors.base0B}";
            yellow = "#${colors.base0A}";
            blue = "#${colors.base0D}";
            magenta = "#${colors.base0E}";
            cyan = "#${colors.base07}";
            white = "#${colors.base06}";
          };
        };
    };
  };
}

