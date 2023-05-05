{ config, pkgs, inputs, ... }:

{
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud26;
    hostName = "cloud.ilanjoselevich.com";
    nginx.recommendedHttpHeaders = true;
    https = true;
    autoUpdateApps.enable = true;
    enableBrokenCiphersForSSE = false;
    config = {
      dbtype = "pgsql";
      adminpassFile = config.age.secrets.nextcloud-admin-root-pass.path;
      adminuser = "admin-root";
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts.${config.services.nextcloud.hostName} = {
      forceSSL = true;
      enableACME = true;
    };
  };

  security.acme = {
    acceptTerms = true;
    certs.${config.services.nextcloud.hostName}.email = "personal@ilanjoselevich.com";
  };

  age.secrets.nextcloud-admin-root-pass = {
    file = "${inputs.self}/secrets/nextcloud-admin-root-pass.age";
    group = "nextcloud";
    owner = "nextcloud";
  };
}
