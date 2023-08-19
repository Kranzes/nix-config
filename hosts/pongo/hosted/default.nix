{ inputs, ... }:

{
  imports = [
    ./libvirt.nix
    ./nextcloud
    ./jellyfin.nix
    ./hercules-ci
    ./oauth2-proxy
    ./grafana
    inputs.self.nixosModules.nginx
  ];
}
