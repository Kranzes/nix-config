
{ config, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    #extraConfig = ''
    #  show-icons  = false;
    #  modi = "drun";
    #  lines = "7";
    #  line-padding = "10";
    #  matching = "fuzzy";
    #  font = "JetBrains Mono 8";
    #  width 30";
    #'';
    theme = {};
  };



}

