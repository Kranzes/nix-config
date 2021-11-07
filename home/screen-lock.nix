{ config, pkgs, ... }:

{

  services.screen-locker = {
    enable = true;
    xautolock.detectSleep = true;
    inactiveInterval = 15;
    lockCmd = "${pkgs.xsecurelock}/bin/xsecurelock";
  };

}

