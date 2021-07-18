
{ config, pkgs, ... }:

{

  programs.ssh = {
    enable = true;
    hashKnownHosts = true;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };

}


