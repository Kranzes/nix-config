{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    layout = "us,il";
    xkbOptions = "grp:lalt_lshift_toggle";
    windowManager.bspwm.enable = true;
    libinput.enable = true;
  };
}
