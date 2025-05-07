{ inputs, ... }:

{
  imports = [
    ./nextcloud.nix
    ./jellyfin.nix
    ./hercules-ci.nix
    ./docker.nix
    ./home-assistant
    inputs.self.nixosModules.hosted-nginx
    inputs.self.nixosModules.hosted-node-exporter
    inputs.self.nixosModules.hosted-libvirt
  ];
}
