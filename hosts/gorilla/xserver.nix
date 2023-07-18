{ pkgs, lib, ... }:

{
  services.xserver = {
    windowManager.bspwm.enable = true;
    displayManager.setupCommands = ''
      echo 0 > /sys/class/leds/platform::micmute/brightness
      echo 0 > /sys/class/leds/platform::mute/brightness
      ${lib.getExe pkgs.xorg.xinput} disable "ETPS/2 Elantech Touchpad"
      ${lib.getExe pkgs.xorg.xinput} disable "Raydium Corporation Raydium Touch System"
    '';
    videoDrivers = [ "amdgpu" ];
    deviceSection = ''
      Option "TearFree" "true"
    '';
  };
}
