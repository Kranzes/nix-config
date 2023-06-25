{ pkgs, lib, ... }:

{
  services.xserver = {
    enable = true;
    layout = "us,il";
    xkbOptions = "grp:lalt_lshift_toggle";
    windowManager.bspwm.enable = true;
    displayManager.setupCommands = ''
      echo 0 > /sys/class/leds/platform::micmute/brightness
      echo 0 > /sys/class/leds/platform::mute/brightness
      ${lib.getExe pkgs.xorg.xinput} disable "ETPS/2 Elantech Touchpad"
      ${lib.getExe pkgs.xorg.xinput} disable "Raydium Corporation Raydium Touch System"
    '';
    displayManager.lightdm.background = "${pkgs.fetchurl { url = "https://i.redd.it/4lkkunczgov61.jpg"; sha256 = "1v1c00xzn1gczp05bwg2dval116cq5qbz20gafw5d9hrlb0b4yzg"; }}";
    videoDrivers = [ "amdgpu" ];
    deviceSection = ''
      Option "TearFree" "true"
    '';
    libinput = {
      enable = true;
      mouse = {
        accelProfile = "flat";
        accelSpeed = "0";
        middleEmulation = false;
      };
      touchpad = {
        accelProfile = "flat";
        accelSpeed = "0";
        middleEmulation = false;
      };
    };
  };
}
