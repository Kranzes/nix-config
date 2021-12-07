{ config, pkgs, ... }:
{

  services.nextcloud = {
    enable = true;
    hostName = "cloud.ilanjoselevich.com";
    ## Enable built-in virtual host management
    ## Takes care of somewhat complicated setup
    ## See here: https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/web-apps/nextcloud.nix#L529

    # Use HTTPS for links
    https = true;

    package = pkgs.nextcloud23;

    logLevel = 0;

    # Auto-update Nextcloud Apps
    autoUpdateApps.enable = true;

    maxUploadSize = "5G";

    config = {

      # Further forces Nextcloud to use HTTPS
      overwriteProtocol = "https";

      # Nextcloud PostegreSQL database configuration, recommended over using SQLite
      dbtype = "pgsql";
      dbuser = "nextcloud";
      dbhost = "/run/postgresql"; # nextcloud will add /.s.PGSQL.5432 by itself
      dbname = "nextcloud";
      dbpassFile = "/var/nextcloud-db-pass";

      adminpassFile = "/var/nextcloud-admin-root-pass";
      adminuser = "admin-root";

      defaultPhoneRegion = "IL";

    };
  };




  services.postgresql = {
    enable = true;

    # Ensure the database, user, and permissions always exist
    ensureDatabases = [ "nextcloud" ];
    ensureUsers = [
      {
        name = "nextcloud";
        ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES";
      }
    ];
  };


  systemd.services."nextcloud-setup" = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };


  security.acme.certs = {
    "cloud.ilanjoselevich.com".email = "personal@ilanjoselevich.com";
  };

  services.nginx.virtualHosts = {

    "cloud.ilanjoselevich.com" = {
      ## Force HTTP redirect to HTTPS
      forceSSL = true;
      ## LetsEncrypt
      enableACME = true;
    };
  };

}



