{ config, ... }:

{
  services.postgresql.enable = true;

  services.postgresqlBackup = {
    enable = true;
    backupAll = true;
    compression = "zstd";
  };

  services.restic.backups.default.paths = [
    config.services.postgresqlBackup.location
  ];
}
