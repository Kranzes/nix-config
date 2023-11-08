{
  services.jellyfin.enable = true;

  services.nginx.virtualHosts."jellyfin.ilanjoselevich.com" = {
    forceSSL = true;
    enableACME = true;
    locations."/".proxyPass = "http://127.0.0.1:8096";
  };
}
