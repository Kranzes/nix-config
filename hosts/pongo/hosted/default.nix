{ inputs, ... }:

{
  imports = [
    ./libvirt.nix
    ./nextcloud
    ./jellyfin.nix
    ./hercules-ci
    ./oauth2-proxy
    inputs.self.nixosModules.nginx
  ];
}
