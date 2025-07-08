{ inputs, ... }:

{
  imports = [
    ./nextcloud.nix
    ./jellyfin.nix
    ./hercules-ci.nix
    ./docker.nix
    ./home-assistant
    ./zigbee2mqtt.nix
    inputs.self.nixosModules.hosted-nginx
    inputs.self.nixosModules.hosted-node-exporter
    inputs.self.nixosModules.hosted-restic
  ];
}
