{ config, pkgs, ... }:

{
  imports = [
    ./server-stuff/nginx.nix
    ./server-stuff/acme.nix
    ./server-stuff/nextcloud.nix
    ./server-stuff/wireguard.nix
    #./server-stuff/searx.nix
    ./server-stuff/netdata.nix
    ./server-stuff/jellyfin.nix
    ./server-stuff/gitea.nix
    ./server-stuff/main-site.nix
  ];

}
