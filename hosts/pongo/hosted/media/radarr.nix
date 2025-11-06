{ config, lib, ... }:
{
  services.radarr = {
    enable = true;
    settings = {
      postgres = {
        host = "/run/postgresql";
      };
    };
  };

  systemd.services.radarr.serviceConfig.SupplementaryGroups = [ "media" ];

  services.postgresql = {
    enable = true;
    ensureDatabases = [
      "radarr-main"
      "radarr-log"
    ];
    ensureUsers = [
      { name = config.services.radarr.user; }
    ];
  };

  systemd.services.postgresql-setup.postStart = lib.mkAfter ''
    psql -tAc '
      ALTER DATABASE "radarr-main" OWNER TO "${config.services.radarr.user}";
      ALTER DATABASE "radarr-log" OWNER TO "${config.services.radarr.user}";
    '
  '';
}
