{ inputs, ... }:

{
  imports = [
    ./libvirt.nix
    ./nextcloud.nix
    ./jellyfin.nix
    ./hercules-ci.nix
    ./docker.nix
    inputs.self.nixosModules.hosted-nginx
    inputs.self.nixosModules.hosted-node-exporter
  ];
}
