{ config, pkgs, self, ... }:

{
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud25;
    hostName = "cloud.ilanjoselevich.com";
    nginx.recommendedHttpHeaders = true;
    https = true;
    autoUpdateApps.enable = true;
    config = {
      dbtype = "pgsql";
      dbhost = "/run/postgresql";
      dbpassFile = config.age.secrets.nextcloud-db-pass.path;
      adminpassFile = config.age.secrets.nextcloud-admin-root-pass.path;
      adminuser = "admin-root";
      defaultPhoneRegion = "IL";
    };
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "${config.services.nextcloud.config.dbname}" ];
    ensureUsers = [{
      name = "${config.services.nextcloud.config.dbuser}";
      ensurePermissions."DATABASE ${config.services.nextcloud.config.dbname}" = "ALL PRIVILEGES";
    }];
  };

  # Ensure nextcloud does not start before its database
  systemd.services."nextcloud-setup" = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };

  services.nginx.virtualHosts."${config.services.nextcloud.hostName}" = {
    forceSSL = true;
    enableACME = true;
  };

  security.acme = {
    acceptTerms = true;
    certs."${config.services.nextcloud.hostName}".email = "personal@ilanjoselevich.com";
  };

  age.secrets = {
    nextcloud-db-pass = {
      file = "${self}/secrets/nextcloud-db-pass.age";
      group = "nextcloud";
      owner = "nextcloud";
    };
    nextcloud-admin-root-pass = {
      file = "${self}/secrets/nextcloud-admin-root-pass.age";
      group = "nextcloud";
      owner = "nextcloud";
    };
  };
}
