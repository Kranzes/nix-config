{
  services.deluge = {
    enable = true;
    web.enable = true;
  };
  systemd.services.deluged.serviceConfig.SupplementaryGroups = [ "media" ];

  networking.firewall.allowedTCPPorts = [ 58946 ];
  networking.firewall.allowedUDPPorts = [ 58946 ];
}
