{ pkgs, ... }:

{
  services.nzbget.enable = true;
  systemd.services.nzbget = {
    path = [ pkgs.python3 ];
    serviceConfig.SupplementaryGroups = [ "media" ];
  };
}
