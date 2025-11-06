{ config, ... }:

{
  programs.rofi = {
    enable = true;
    font = "JetBrainsMonoNL Nerd Font 8";
    extraConfig = {
      dpi = config.xresources.properties."Xft.dpi";
      modi = [ "drun" ];
      matching = "fuzzy";
    };
    theme =
      let
        inherit (config.lib.formats.rasi) mkLiteral;
      in
      {
        # catppuccin macchiato
        "*" = {
          background-color = mkLiteral "#24273A";
          text-color = mkLiteral "#CAD3F5";
          border-color = mkLiteral "#91D7E3";
        };
        window.width = mkLiteral "25%";
        mainbox = {
          border = 3;
          padding = 10;
        };
        listview = {
          lines = 8;
          spacing = 5;
          padding = mkLiteral "5 0 0";
        };
        element.padding = 2;
        "element.selected".background-color = mkLiteral "#363A4F";
        element-text.background-color = mkLiteral "inherit";
        inputbar = {
          spacing = 5;
          padding = 5;
          border = mkLiteral "0 0 1";
          border-color = mkLiteral "#A6DA95";
        };
      };
  };

  catppuccin.rofi.enable = false;
}
