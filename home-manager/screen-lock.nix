{ config, pkgs, ... }:

{

  services.screen-locker = {
    enable = true;
    enableDetectSleep = true;
    inactiveInterval = 15;
    lockCmd = "${pkgs.xsecurelock}/bin/xsecurelock";
  };

}

