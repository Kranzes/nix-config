{ pkgs, ... }:

{
  services.dunst = {
    enable = true;
    settings = {
      global.font = "JetBrains Mono 10";

      # catppuccin macchiato
      global = {
        frame_color = "#8AADF4";
        separator_color = "frame";
      };

      urgency_low = {
        background = "#24273A";
        foreground = "#CAD3F5";
      };

      urgency_normal = {
        background = "#24273A";
        foreground = "#CAD3F5";
      };

      urgency_critical = {
        background = "#24273A";
        foreground = "#CAD3F5";
        frame_color = "#F5A97F";
      };
    };
  };

  home.packages = [ pkgs.libnotify ];
}
