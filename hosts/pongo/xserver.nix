{ pkgs, ... }:

{
  services.xserver = {
    videoDrivers = [ "amdgpu" ];
    windowManager.bspwm.enable = true;
    displayManager.setupCommands = ''
      ${pkgs.xorg.xrandr}/bin/xrandr --output DisplayPort-0 --rate 240 --mode 1920x1080 --primary
      ${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-A-0 --mode 1920x1080 --same-as DisplayPort-0
      ${pkgs.xcalib}/bin/xcalib /home/kranzes/.xcalib/asus_rog_swift_pg258q.icc || true
    '';
  };
}
