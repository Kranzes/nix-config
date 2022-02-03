{ config, pkgs, ... }:

{
  services.openssh = {
    enable = true;
    forwardX11 = true;
    passwordAuthentication = false;
    kbdInteractiveAuthentication = false;
    permitRootLogin = "no";
  };
}

