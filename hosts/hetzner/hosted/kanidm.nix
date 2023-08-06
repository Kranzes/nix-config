{ config, ... }:
let
  domain = "idm.ilanjoselevich.com";
  certDir = config.security.acme.certs.${domain}.directory;
in
{
  security.acme = {
    acceptTerms = true;
    certs.${domain}.email = "personal@ilanjoselevich.com";
  };

  services.kanidm = {
    enableServer = true;
    serverSettings = {
      inherit domain;
      origin = "https://${domain}";
      bindaddress = "127.0.0.1:8443";
      trust_x_forward_for = true;
      tls_chain = "${certDir}/fullchain.pem";
      tls_key = "${certDir}/key.pem";
      online_backup = {
        path = "/var/lib/kanidm/backups";
        schedule = "0 0 * * *"; # Every day at midnight.
      };
    };
  };

  systemd.services.kanidm = {
    after = [ "acme-selfsigned-internal.${domain}.target" ];
    serviceConfig = {
      SupplementaryGroups = [ config.security.acme.certs.${domain}.group ];
      BindReadOnlyPaths = [ certDir ];
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts.${domain} = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "https://${config.services.kanidm.serverSettings.bindaddress}";
    };
  };

  environment.persistence."/nix/persistent".directories = [
    "/var/lib/acme"
    "/var/lib/kanidm"
  ];
}
