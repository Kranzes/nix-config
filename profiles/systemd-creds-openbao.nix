{ inputs, ... }:
{ config, lib, ... }:
{
  imports = [ inputs.systemd-creds-openbao.nixosModules.default ];

  services.systemd-creds-openbao = {
    enable = true;
    environment.BAO_ADDR = "https://secret.ilanjoselevich.com";
    credentials.openbao-secret-id = config.age.secrets.openbao-secret-id.path;
    settings = {
      openbao.auth = {
        method = "approle";
        role_id = config.networking.hostName;
        secret_id_file = "\${CREDENTIALS_DIRECTORY}/openbao-secret-id";
      };
      # Ordering matters.
      credentials = lib.mkAfter [
        {
          unit = "*";
          path = "${config.networking.hostName}/systemd/{unit_name}";
        }
      ];
    };
  };

  age.secrets.openbao-secret-id.file = ../secrets/${config.networking.hostName}-openbao-secret-id.age;
}
