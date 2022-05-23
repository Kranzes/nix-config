{ config, pkgs, ... }:

{
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud24;
    hostName = "cloud.ilanjoselevich.com";
    nginx.recommendedHttpHeaders = true;
    https = true;
    autoUpdateApps.enable = true;
    config = {
      dbtype = "pgsql";
      dbhost = "/run/postgresql";
      dbpassFile = "/var/nextcloud-db-pass";
      adminpassFile = "/var/nextcloud-admin-root-pass";
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
}
