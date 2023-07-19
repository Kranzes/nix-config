{
  programs.alacritty = {
    enable = true;
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
      colors = {
        primary = {
          background = "#2e3440";
          dim_foreground = "#a5abb6";
          foreground = "#d8dee9";
        };
        cursor = {
          cursor = "#d8dee9";
          text = "#2e3440";
        };
        vi_mode_cursor = {
          cursor = "#d8dee9";
          text = "#2e3440";
        };
        selection = {
          background = "#4c566a";
          text = "CellForeground";
        };
        search = {
          footer_bar = {
            background = "#434c5e";
            foreground = "#d8dee9";
          };
          matches = {
            background = "#88c0d0";
            foreground = "CellBackground";
          };
        };
        normal = {
          black = "#3b4252";
          blue = "#81a1c1";
          cyan = "#88c0d0";
          green = "#a3be8c";
          magenta = "#b48ead";
          red = "#bf616a";
          white = "#e5e9f0";
          yellow = "#ebcb8b";
        };
        bright = {
          black = "#4c566a";
          blue = "#81a1c1";
          cyan = "#8fbcbb";
          green = "#a3be8c";
          magenta = "#b48ead";
          red = "#bf616a";
          white = "#eceff4";
          yellow = "#ebcb8b";
        };
        dim = {
          black = "#373e4d";
          blue = "#68809a";
          cyan = "#6d96a5";
          green = "#809575";
          magenta = "#8c738c";
          red = "#94545d";
          white = "#aeb3bb";
          yellow = "#b29e75";
        };
      };
    };
  };
}
