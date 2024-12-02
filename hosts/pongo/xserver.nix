{ pkgs, config, ... }:

{
  services.xserver = {
    windowManager.bspwm.enable = true;
    displayManager.setupCommands = ''
      ${pkgs.xorg.xrandr}/bin/xrandr --output DP-0 --rate 240 --mode 1920x1080 --primary
      ${pkgs.xcalib}/bin/xcalib /home/kranzes/.xcalib/asus_rog_swift_pg258q.icc
    '';
    videoDrivers = [ "nvidia" ];
    deviceSection = ''
      Option "Coolbits" "28"
    '';
  };

  hardware.nvidia.open = false; # Older GPUs are not supported in the open drivers.
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
}
