{ inputs, ... }:

{
  imports = [
    ./nextcloud.nix
    ./hercules-ci.nix
    ./docker.nix
    ./home-assistant
    ./zigbee2mqtt.nix
    ./media
    inputs.self.nixosModules.hosted-nginx
    inputs.self.nixosModules.hosted-node-exporter
    inputs.self.nixosModules.hosted-restic
  ];
}
