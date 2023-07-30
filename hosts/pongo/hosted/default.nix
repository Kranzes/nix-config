{ inputs, ... }:

{
  imports = [
    ./libvirt.nix
    ./nextcloud
    ./jellyfin.nix
    ./hercules-ci
    inputs.self.nixosModules.nginx
  ];
}
