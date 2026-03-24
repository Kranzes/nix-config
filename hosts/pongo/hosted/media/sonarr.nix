{ config, lib, ... }:
{
  services.sonarr = {
    enable = true;
    settings = {
      postgres = {
        host = "/run/postgresql";
      };
    };
  };

  systemd.services.sonarr.serviceConfig = {
    ProtectHome = lib.mkForce false;
    SupplementaryGroups = [ "media" ];
  };

  services.postgresql = {
    ensureDatabases = [
      "sonarr-main"
      "sonarr-log"
    ];
    ensureUsers = [
      { name = config.services.sonarr.user; }
    ];
  };

  systemd.services.postgresql-setup.postStart = lib.mkAfter ''
    psql -tAc '
      ALTER DATABASE "sonarr-main" OWNER TO "${config.services.sonarr.user}";
      ALTER DATABASE "sonarr-log" OWNER TO "${config.services.sonarr.user}";
    '
  '';
}
