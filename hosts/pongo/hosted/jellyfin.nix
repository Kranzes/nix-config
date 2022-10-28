let
  domain = "jellyfin.ilanjoselevich.com";
in
{
  services.jellyfin.enable = true;

  services.nginx = {
    enable = true;
    virtualHosts.${domain} = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://127.0.0.1:8096";
    };
  };

  security.acme = {
    acceptTerms = true;
    certs.${domain}.email = "personal@ilanjoselevich.com";
  };
}
