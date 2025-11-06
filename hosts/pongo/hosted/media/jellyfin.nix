{
  services.jellyfin.enable = true;
  systemd.services.jellyfin.serviceConfig.SupplementaryGroups = [ "media" ];

  services.nginx.virtualHosts."jellyfin.ilanjoselevich.com" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8096";
      proxyWebsockets = true;
    };
    extraConfig = ''
      proxy_buffering off;
    '';
  };
}
