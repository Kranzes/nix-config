{ inputs, ... }:

{
  imports = [
    ./libvirt.nix
    ./nextcloud
    ./jellyfin.nix
    ./hercules-ci
    ./oauth2-proxy
    ./grafana
    ./loki.nix
    inputs.self.nixosModules.grafana-agent
    inputs.self.nixosModules.nginx
  ];
}
