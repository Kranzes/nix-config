{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    layout = "us,il";
    xkbOptions = "grp:lalt_lshift_toggle";
    windowManager.bspwm.enable = true;
    displayManager.lightdm.background = "${pkgs.fetchurl { url = "https://i.redd.it/4lkkunczgov61.jpg"; sha256 = "1v1c00xzn1gczp05bwg2dval116cq5qbz20gafw5d9hrlb0b4yzg"; }}";
    videoDrivers = [ "intel" ];
    deviceSection = ''
      Option "DRI" "2"
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
