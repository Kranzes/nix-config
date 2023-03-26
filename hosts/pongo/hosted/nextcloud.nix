{ config, pkgs, inputs, ... }:
let
  domain = "cloud.ilanjoselevich.com";
in
{
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud26;
    hostName = domain;
    nginx.recommendedHttpHeaders = true;
    enableBrokenCiphersForSSE = false;
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
    ensureDatabases = [ config.services.nextcloud.config.dbname ];
    ensureUsers = [{
      name = config.services.nextcloud.config.dbuser;
      ensurePermissions."DATABASE ${config.services.nextcloud.config.dbname}" = "ALL PRIVILEGES";
    }];
  };

  # Ensure nextcloud does not start before its database
  systemd.services."nextcloud-setup" = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };

  services.nginx = {
    enable = true;
    virtualHosts.${domain} = {
      forceSSL = true;
      enableACME = true;
    };
  };

  security.acme = {
    acceptTerms = true;
    certs.${domain}.email = "personal@ilanjoselevich.com";
  };

  age.secrets = {
    nextcloud-db-pass = {
      file = "${inputs.self}/secrets/nextcloud-db-pass.age";
      group = "nextcloud";
      owner = "nextcloud";
    };
    nextcloud-admin-root-pass = {
      file = "${inputs.self}/secrets/nextcloud-admin-root-pass.age";
      group = "nextcloud";
      owner = "nextcloud";
    };
  };
}
