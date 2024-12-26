{ pkgs, config, lib, ... }:
let
  domain = "idm.ilanjoselevich.com";
  certDir = config.security.acme.certs.${domain}.directory;
in
{
  services.kanidm = {
    package = lib.mkForce pkgs.kanidm_1_4.withSecretProvisioning;
    enableServer = true;
    serverSettings = {
      inherit domain;
      origin = "https://${domain}";
      trust_x_forward_for = true;
      tls_chain = "${certDir}/fullchain.pem";
      tls_key = "${certDir}/key.pem";
      online_backup = {
        path = "/var/lib/kanidm/backups";
        versions = 7;
        schedule = "0 0 * * *"; # Every day at midnight.
      };
    };
    provision = {
      enable = true;

      groups = lib.genAttrs [
        "tailscale_users"
        "nextcloud_users"
        "jellyfin_users"
        "jellyfin_admins"
        "grafana_users"
        "grafana_admins"
      ]
        (_: { });

      persons."kranzes" = {
        displayName = "Kranzes";
        legalName = "Ilan Joselevich";
        mailAddresses = [ "personal@ilanjoselevich.com" ];
        # Add to all groups
        groups = lib.attrNames config.services.kanidm.provision.groups;
      };

      systems.oauth2 = {
        "tailscale" = {
          displayName = "Tailscale";
          originUrl = "https://login.tailscale.com/a/oauth_response";
          originLanding = "https://login.tailscale.com";
          preferShortUsername = true;
          allowInsecureClientDisablePkce = true;
          scopeMaps."tailscale_users" = [ "openid" "profile" "email" ];
        };
        "nextcloud" = {
          displayName = "Nextcloud";
          originUrl = "https://cloud.ilanjoselevich.com/apps/user_oidc/code";
          originLanding = "https://cloud.ilanjoselevich.com";
          preferShortUsername = true;
          scopeMaps."nextcloud_users" = [ "openid" ];
        };
        "jellyfin" = {
          displayName = "Jellyfin";
          originUrl = [
            "https://jellyfin.ilanjoselevich.com/sso/OID/redirect/Kanidm"
            "https://jellyfin.ilanjoselevich.com/sso/OID/r/Kanidm"
          ];
          originLanding = "https://jellyfin.ilanjoselevich.com";
          preferShortUsername = true;
          scopeMaps."jellyfin_users" = [ "openid" "profile" "groups" ];
        };
        "grafana" = {
          displayName = "Grafana";
          originUrl = "https://monitoring.ilanjoselevich.com/login/generic_oauth";
          originLanding = "https://monitoring.ilanjoselevich.com";
          preferShortUsername = true;
          scopeMaps."grafana_users" = [ "openid" "profile" "email" "groups" ];
          basicSecretFile = config.age.secrets.oauth2-grafana-basic-secret.path;
        };
      };
    };
  };

  systemd.services.kanidm = {
    after = [ "acme-selfsigned-internal.${domain}.target" ];
    serviceConfig.SupplementaryGroups = [ config.security.acme.certs.${domain}.group ];
  };

  services.nginx.virtualHosts.${domain} = {
    forceSSL = true;
    enableACME = true;
    locations."/".proxyPass = "https://${config.services.kanidm.serverSettings.bindaddress}";
  };

  environment.persistence."/nix/persistent".directories = [
    "/var/lib/kanidm"
  ];

  age.secrets.oauth2-grafana-basic-secret = {
    file = ../../../secrets/${config.networking.hostName}-oauth2-grafana-basic-secret.age;
    owner = "grafana";
    group = "grafana";
  };
}
