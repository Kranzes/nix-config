{ config, pkgs, ... }:

{
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud35;
    hostName = "cloud.ilanjoselevich.com";
    https = true;
    autoUpdateApps.enable = true;
    database.createLocally = true;
    configureRedis = true;
    config = {
      dbtype = "pgsql";
      adminpassFile = config.services.systemd-creds-openbao.socketPath;
      adminuser = "admin-root";
    };
    settings.user_oidc.use_pkce = true;
    phpOptions."opcache.interned_strings_buffer" = "16";
  };

  systemd.services.nextcloud-setup = {
    wants = [ "systemd-creds-openbao.service" ];
    after = [ "systemd-creds-openbao.service" ];
  };

  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    enableACME = true;
  };
}
