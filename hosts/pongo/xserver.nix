{ pkgs, lib, ... }:

{
  services.xserver = {
    windowManager.bspwm.enable = true;
    displayManager.setupCommands = ''
      ${lib.getExe pkgs.xorg.xrandr} --output DP-0 --rate 240 --mode 1920x1080
      ${lib.getExe pkgs.xcalib} /home/kranzes/.xcalib/asus_rog_swift_pg258q.icc
    '';
    videoDrivers = [ "nvidia" ];
    deviceSection = ''
      Option "Coolbits" "28"
    '';
  };
}
