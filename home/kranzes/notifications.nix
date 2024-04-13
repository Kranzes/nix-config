{ pkgs, ... }:

{
  services.dunst = {
    enable = true;
    catppuccin.enable = true;
    settings.global.font = "JetBrains Mono 10";
  };

  home.packages = [ pkgs.libnotify ];
}
