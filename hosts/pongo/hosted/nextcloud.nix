{ config, pkgs, ... }:

{
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud27;
    hostName = "cloud.ilanjoselevich.com";
    nginx.recommendedHttpHeaders = true;
    https = true;
    autoUpdateApps.enable = true;
    database.createLocally = true;
    configureRedis = true;
    config = {
      dbtype = "pgsql";
      adminpassFile = config.age.secrets.nextcloud-admin-root-pass.path;
      adminuser = "admin-root";
    };
  };

  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    enableACME = true;
  };

  age.secrets.nextcloud-admin-root-pass = {
    file = ../../../secrets/${config.networking.hostName}-nextcloud-admin-root-pass.age;
    group = "nextcloud";
    owner = "nextcloud";
  };
}
