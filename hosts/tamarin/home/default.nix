{ lib, pkgs, ... }:

{
  # Overrides.
  home-manager.users.kranzes = {
    services.batsignal.enable = true;
    services.polybar.script = lib.mkForce ''
      polybar rightbar &
      polybar leftbar &
    '';
    xresources.properties."Xft.dpi" = 144; # 150%
    xsession.windowManager.bspwm.startupPrograms = [
      "${lib.getExe pkgs.feh} --no-fehbg --bg-scale $HOME/Wallpapers/socotra-dune.jpg"
    ];
  };
}
