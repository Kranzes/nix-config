{
  pkgs,
  config,
  lib,
  ...
}:
let
  domain = "idm.ilanjoselevich.com";
  certDir = config.security.acme.certs.${domain}.directory;
  credential = name: "/run/credentials/kanidm.service/${name}";
in
{
  services.kanidm = {
    package = lib.mkForce pkgs.kanidm_1_11.withSecretProvisioning;
    server = {
      enable = true;
      settings = {
        inherit domain;
        origin = "https://${domain}";
        http_client_address_info.x-forward-for = [ "127.0.0.1" ];
        tls_chain = "${certDir}/fullchain.pem";
        tls_key = "${certDir}/key.pem";
        online_backup = {
          path = "/var/lib/kanidm/backups";
          versions = 7;
          schedule = "0 0 * * *"; # Every day at midnight.
        };
      };
    };
    provision = {
      enable = true;
      extraJsonFile = credential "extra-json";

      groups = lib.genAttrs [
        "tailscale_users"
        "nextcloud_users"
        "jellyfin_users"
        "jellyfin_admins"
        "grafana_users"
        "grafana_admins"
        "home-assistant_users"
        "home-assistant_admins"
        "seerr_users"
        "seerr_admins"
        "openbao_admins"
      ] (_: { });

      persons = {
        "kranzes" = {
          displayName = "Kranzes";
          legalName = "Ilan Joselevich";
          mailAddresses = [ "personal@ilanjoselevich.com" ];
          # Add to all groups
          groups = lib.attrNames config.services.kanidm.provision.groups;
        };
        "arianvp" = {
          displayName = "arianvp";
          legalName = "Arian van Putten";
          mailAddresses = [ "jellyfin@arianvp.me" ];
          groups = [
            "jellyfin_users"
            "seerr_users"
          ];
        };
      };

      systems.oauth2 = {
        "tailscale" = {
          displayName = "Tailscale";
          originUrl = "https://login.tailscale.com/a/oauth_response";
          originLanding = "https://login.tailscale.com";
          preferShortUsername = true;
          allowInsecureClientDisablePkce = true;
          scopeMaps."tailscale_users" = [
            "openid"
            "profile"
            "email"
          ];
          basicSecretFile = credential "oauth2-tailscale";
        };
        "nextcloud" = {
          displayName = "Nextcloud";
          originUrl = "https://cloud.ilanjoselevich.com/apps/user_oidc/code";
          originLanding = "https://cloud.ilanjoselevich.com";
          preferShortUsername = true;
          scopeMaps."nextcloud_users" = [ "openid" ];
          basicSecretFile = credential "oauth2-nextcloud";
        };
        "jellyfin" = {
          displayName = "Jellyfin";
          originUrl = "https://jellyfin.ilanjoselevich.com/sso/OID/redirect/Kanidm";
          originLanding = "https://jellyfin.ilanjoselevich.com";
          preferShortUsername = true;
          scopeMaps."jellyfin_users" = [
            "openid"
            "profile"
            "groups"
          ];
          basicSecretFile = credential "oauth2-jellyfin";
        };
        "grafana" = {
          displayName = "Grafana";
          originUrl = "https://monitoring.ilanjoselevich.com/login/generic_oauth";
          originLanding = "https://monitoring.ilanjoselevich.com";
          preferShortUsername = true;
          scopeMaps."grafana_users" = [
            "openid"
            "profile"
            "email"
            "groups"
          ];
          basicSecretFile = credential "oauth2-grafana";
        };
        "home-assistant" = {
          displayName = "Home Assistant";
          originUrl = "https://home.ilanjoselevich.com/auth/oidc/callback";
          originLanding = "https://home.ilanjoselevich.com";
          preferShortUsername = true;
          scopeMaps."home-assistant_users" = [
            "openid"
            "profile"
            "groups"
          ];
          basicSecretFile = credential "oauth2-home-assistant";
        };
        "seerr" = {
          displayName = "Seerr";
          originUrl = [
            "https://seerr.ilanjoselevich.com/login"
            "https://seerr.ilanjoselevich.com/profile/settings/linked-accounts"
          ];
          originLanding = "https://seerr.ilanjoselevich.com";
          preferShortUsername = true;
          scopeMaps."seerr_users" = [
            "openid"
            "profile"
            "email"
          ];
          basicSecretFile = credential "oauth2-seerr";
        };
        "openbao" = {
          displayName = "OpenBao";
          originUrl = [
            "https://secret.ilanjoselevich.com/ui/vault/auth/oidc/oidc/callback"
            "http://localhost:8250/oidc/callback"
          ];
          originLanding = "https://secret.ilanjoselevich.com";
          preferShortUsername = true;
          scopeMaps."openbao_admins" = [
            "openid"
            "profile"
            "groups"
          ];
          basicSecretFile = credential "oauth2-openbao";
        };
      };
    };
  };

  systemd.services.kanidm = {
    requires = [ "systemd-creds-openbao.service" ];
    after = [
      "acme-selfsigned-internal.${domain}.target"
      "systemd-creds-openbao.service"
    ];

    serviceConfig = {
      SupplementaryGroups = [ config.security.acme.certs.${domain}.group ];
      LoadCredential = map (name: "${name}:${config.services.systemd-creds-openbao.socketPath}") [
        "extra-json"
        "oauth2-tailscale"
        "oauth2-nextcloud"
        "oauth2-jellyfin"
        "oauth2-grafana"
        "oauth2-home-assistant"
        "oauth2-seerr"
        "oauth2-openbao"
      ];
    };
  };

  services.nginx.virtualHosts.${domain} = {
    forceSSL = true;
    enableACME = true;
    locations."/".proxyPass = "https://${config.services.kanidm.server.settings.bindaddress}";
  };

  services.restic.backups.default.paths = [
    config.services.kanidm.server.settings.online_backup.path
  ];
}
