{ pkgs, ... }:

{
  xsession.windowManager.bspwm = {
    startupPrograms = [
      "${pkgs.feh}/bin/feh --no-fehbg --bg-scale $HOME/Wallpapers/monkeys.jpg"
    ];
    monitors.eDP = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" ];
  };
}
