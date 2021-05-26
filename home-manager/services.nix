{ config, pkgs, ... }:

{

  services = {
    nextcloud-client.enable = true;
    network-manager-applet.enable = true;
  };

}

