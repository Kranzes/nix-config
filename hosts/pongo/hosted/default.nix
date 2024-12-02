{ inputs, ... }:

{
  imports = [
    ./libvirt.nix
    ./nextcloud.nix
    ./jellyfin.nix
    ./hercules-ci.nix
    inputs.self.nixosModules.hosted-nginx
  ];
}
