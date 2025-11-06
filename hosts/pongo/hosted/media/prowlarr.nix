{ lib, ... }:

{
  users.users.prowlarr = {
    isSystemUser = true;
    group = "prowlarr";
  };
  users.groups.prowlarr = { };

  services.prowlarr = {
    enable = true;
    settings = {
      postgres = {
        host = "/run/postgresql";
      };
    };
  };

  systemd.services.prowlarr.serviceConfig.User = "prowlarr";

  services.postgresql = {
    enable = true;
    ensureDatabases = [
      "prowlarr-main"
      "prowlarr-log"
    ];
    ensureUsers = [
      { name = "prowlarr"; }
    ];
  };

  systemd.services.postgresql-setup.postStart = lib.mkAfter ''
    psql -tAc '
      ALTER DATABASE "prowlarr-main" OWNER TO "prowlarr";
      ALTER DATABASE "prowlarr-log" OWNER TO "prowlarr";
    '
  '';
}
