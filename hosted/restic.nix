{ config, ... }:

{
  age.secrets = {
    restic-default-env-file.file = ../secrets/${config.networking.hostName}-restic-default-env-file.age;
    restic-default-repo-password.file = ../secrets/${config.networking.hostName}-restic-default-repo-password.age;
  };

  services.restic.backups.default = {
    repository = "s3:https://s3.eu-central-003.backblazeb2.com/kranzes-backups/${config.networking.hostName}";
    initialize = true;
    environmentFile = config.age.secrets.restic-default-env-file.path;
    passwordFile = config.age.secrets.restic-default-repo-password.path;
  };
}
