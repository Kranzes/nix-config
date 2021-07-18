{ config, pkgs, ... }:

{

  programs.ssh = {
    enable = true;
    hashKnownHosts = true;
  };

  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryFlavor = "curses";
  };

}

