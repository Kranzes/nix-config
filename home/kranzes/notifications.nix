{ pkgs, ... }:

{
  services.dunst = {
    enable = true;
    settings.global.font = "JetBrainsMonoNL Nerd Font 10";
  };

  home.packages = [ pkgs.libnotify ];
}
