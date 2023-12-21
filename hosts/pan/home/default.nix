{ pkgs, lib, ... }:

{
  # Overrides.
  home-manager.users.kranzes = {
    services.batsignal.enable = true;
    services.polybar.script = lib.mkForce ''
      polybar rightbar &
      polybar leftbar &
    '';
    xsession.windowManager.bspwm.startupPrograms = [
      "${lib.getExe pkgs.feh} --no-fehbg --bg-scale $HOME/Wallpapers/nord-lake.png"
    ];
  };
}
