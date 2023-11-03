{ inputs, ... }:

{
  imports = [
    ./libvirt.nix
    ./nextcloud.nix
    ./jellyfin.nix
    ./hercules-ci
    ./oauth2-proxy.nix
    ./grafana.nix
    ./loki.nix
    inputs.self.nixosModules.grafana-agent
    inputs.self.nixosModules.nginx
  ];
}
