{ pkgs, ... }:

{
  xsession.windowManager.bspwm.startupPrograms = [
    "${pkgs.feh}/bin/feh --no-fehbg --bg-scale $HOME/Wallpapers/monkeys.jpg"
  ];
}
