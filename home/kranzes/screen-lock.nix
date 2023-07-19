{ pkgs, lib, ... }:

{
  services.screen-locker = {
    enable = true;
    xautolock.detectSleep = true;
    inactiveInterval = 15;
    lockCmd = lib.getExe pkgs.xsecurelock;
  };
}
