{ config, pkgs, ... }:

{

  services.screen-locker = {
    enable = true;
    enableDetectSleep = true;
    inactiveInterval = 10;
    lockCmd = "${pkgs.xsecurelock}/bin/xsecurelock";
  };

}

