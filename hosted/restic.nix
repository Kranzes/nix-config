{ config, ... }:

{
  services.restic.backups.default = {
    repository = "s3:https://s3.eu-central-003.backblazeb2.com/kranzes-backups/${config.networking.hostName}";
    initialize = true;
    passwordFile = "/run/credentials/restic-backups-default.service/password";
  };

  systemd.services.restic-backups-default = {
    environment.AWS_SHARED_CREDENTIALS_FILE = "/run/credentials/restic-backups-default.service/aws-credentials";
    serviceConfig.LoadCredential = [
      "password:${config.services.systemd-creds-openbao.socketPath}"
      "aws-credentials:${config.services.systemd-creds-openbao.socketPath}"
    ];
  };
}
