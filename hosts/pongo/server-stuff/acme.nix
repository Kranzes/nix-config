{ config, pkgs, ... }:

{

  security.acme = {
    acceptTerms = true;
    defaults.renewInterval = "daily";
    defaults.email = "personal@ilanjoselevich.com";
    certs."jellyfin.ilanjoselevich.com" = {
      extraDomainNames = map (subdomain: "${subdomain}.ilanjoselevich.com") [
        "git"
        "stats"
      ];
    };
  };

}

