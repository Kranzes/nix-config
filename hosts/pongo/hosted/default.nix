{ inputs, ... }:

{
  imports = [
    ./libvirt.nix
    ./nextcloud.nix
    ./jellyfin.nix
    ./hercules-ci.nix
    ./grafana.nix
    ./loki.nix
    inputs.self.nixosModules.hosted-grafana-agent
    inputs.self.nixosModules.hosted-nginx
  ];
}
