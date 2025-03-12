{ pkgs, ... }:

{
  imports = [
    ./nvidia.nix
  ];

  services.xserver = {
    windowManager.bspwm.enable = true;
    displayManager.setupCommands = ''
      ${pkgs.xorg.xrandr}/bin/xrandr --output DP-0 --rate 240 --mode 1920x1080 --primary || true
      ${pkgs.xcalib}/bin/xcalib /home/kranzes/.xcalib/asus_rog_swift_pg258q.icc || true
    '';
  };
}
