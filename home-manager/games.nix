{ config, pkgs, ... }:

{

  home.packages = with pkgs; [
    steam
    steam.run
    lutris
  ];

  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
  };  

}
