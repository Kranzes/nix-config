{ inputs, ... }:
{ config, lib, ... }:
{
  imports = [ inputs.systemd-creds-openbao.nixosModules.default ];

  services.systemd-creds-openbao = {
    enable = true;
    environment.BAO_ADDR = "https://secret.ilanjoselevich.com";
    settings = {
      openbao = {
        serve_stale_for = "1h";
        auth = {
          method = "approle";
          role_id = config.networking.hostName;
          secret_id_file = "\${CREDENTIALS_DIRECTORY}/openbao-secret-id";
        };
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

  systemd.services.systemd-creds-openbao.serviceConfig.ImportCredential = [
    "openbao-secret-id"
  ];
}
