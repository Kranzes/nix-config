{
  imports = [
    ./server-stuff/nginx.nix
    ./server-stuff/acme.nix
    ./server-stuff/nextcloud.nix
    ./server-stuff/jellyfin.nix
    ./server-stuff/gitea.nix
    #./server-stuff/hercules-ci.nix
  ];
}
