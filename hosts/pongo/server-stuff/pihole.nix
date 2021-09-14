{ config, pkgs, ... }:

{

  virtualisation.oci-containers = {
    backend = "podman";
    containers."pihole" = {
      image = "docker.io/pihole/pihole:latest";
      volumes = [ "/etc/pihole/:/etc/pihole/" "/etc/dnsmasq.d/:/etc/dnsmasq.d/" ];
      ports = [ "53:53/tcp" "53:53/udp" "2570:2570" ];
      environment = { WEB_PORT = "2570"; ServerIP = "192.168.1.110"; TZ = "Asia/Jerusalem"; };
      autoStart = true;
    };
  };

  networking.firewall = {
    allowedUDPPorts = [ 53 2570 ];
    allowedTCPPorts = [ 53 2570 ];
  };

}

