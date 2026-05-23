{
  config,
  pkgs,
  lib,
  ...
}:

{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_18;
    settings = {
      listen_addresses = lib.mkForce ""; # UNIX socket only.
      log_destination = lib.mkForce "syslog";
    };
  };

  services.postgresqlBackup = {
    enable = true;
    backupAll = true;
    compression = "zstd";
  };

  services.restic.backups.default.paths = [
    config.services.postgresqlBackup.location
  ];
}
