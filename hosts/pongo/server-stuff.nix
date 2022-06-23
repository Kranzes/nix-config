{ config, pkgs, ... }:

{
  imports = [
    ./server-stuff/nginx.nix
    ./server-stuff/acme.nix
    ./server-stuff/nextcloud.nix
    ./server-stuff/netdata.nix
    ./server-stuff/jellyfin.nix
    ./server-stuff/gitea.nix
  ];

}

