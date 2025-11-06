{
  users.groups.media = { };

  imports = [
    ./nzbget.nix
    ./deluge.nix
    ./prowlarr.nix
    ./radarr.nix
    ./sonarr.nix
    ./recyclarr.nix
    ./jellyfin.nix
    ./jellyseerr.nix
  ];
}
