{ lib, config, ... }:
{
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [ "systemd" ];
  };

  networking.firewall.interfaces = lib.mkIf config.services.tailscale.enable {
    ${config.services.tailscale.interfaceName}.allowedTCPPorts = [
      config.services.prometheus.exporters.node.port
    ];
  };
}
