{ config, pkgs, ... }:

{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_18;
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
