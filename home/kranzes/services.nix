{ config, pkgs, ... }:

{
  services = {
    nextcloud-client.enable = true;
    nextcloud-client.startInBackground = true;
    network-manager-applet.enable = true;
  };
}

