{ config, pkgs, ... }:

{

  security.acme = {
    acceptTerms = true;
    renewInterval = "daily";
    email = "personal@ilanjoselevich.com";
    certs."ilanjoselevich.com" = {
      extraDomainNames = map (subdomain: "${subdomain}.ilanjoselevich.com") [
        "git"
        "stats"
        "jellyfin"
      ];
    };
  };

}

