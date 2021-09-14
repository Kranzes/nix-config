{ config, pkgs, ... }:

{
  services.netdata.enable = true;

  networking.firewall.allowedTCPPorts = [ 19999 ];
  networking.firewall.allowedUDPPorts = [ 19999 ];
}

