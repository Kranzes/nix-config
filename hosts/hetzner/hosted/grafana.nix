{ config, ... }:
let
  domain = "monitoring.ilanjoselevich.com";
in
{
  services.grafana = {
    enable = true;
    settings = {
      server = {
        inherit domain;
        root_url = "https://${domain}";
        protocol = "socket";
      };
      database = {
        type = "postgres";
        host = "/run/postgresql";
        user = "grafana";
      };
      log.mode = "syslog";
      security = {
        secret_key = "$__file{/run/credentials/grafana.service/grafana_signing_key}";
        cookie_secure = true;
        disable_gravatar = true;
        disable_initial_admin_creation = true;
      };
      auth = {
        disable_login_form = true;
        disable_signout_menu = true;
      };
      "auth.basic".enabled = false;
      "auth.generic_oauth" = {
        enabled = true;
        name = "Kanidm";
        client_id = "grafana";
        client_secret = "$__file{/run/credentials/grafana.service/kanidm_client_secret}";
        scopes = "openid profile email groups";
        auth_url = "https://idm.ilanjoselevich.com/ui/oauth2";
        token_url = "https://idm.ilanjoselevich.com/oauth2/token";
        api_url = "https://idm.ilanjoselevich.com/oauth2/openid/grafana/userinfo";
        use_pkce = true;
        use_refresh_token = true;
        allow_sign_up = true;
        auto_login = true;
        allow_assign_grafana_admin = true;
        role_attribute_path = "contains(groups[*], 'grafana_admins@idm.ilanjoselevich.com') && 'GrafanaAdmin' || 'Viewer'";
        role_attribute_strict = true;
        login_attribute_path = "preferred_username";
      };
      analytics = {
        reporting_enabled = false;
        feedback_links_enabled = false;
      };
    };
  };

  age.secrets.grafana-signing-key.file = ../../../secrets/${config.networking.hostName}-grafana-signing-key.age;

  systemd.services.grafana.serviceConfig.LoadCredential = [
    "grafana_signing_key:${config.age.secrets.grafana-signing-key.path}"
    "kanidm_client_secret:${config.services.kanidm.provision.systems.oauth2.grafana.basicSecretFile}"
  ];

  services.postgresql = {
    enable = true;
    ensureDatabases = [ config.services.grafana.settings.database.name ];
    ensureUsers = [
      {
        name = config.services.grafana.settings.database.user;
        ensureDBOwnership = true;
      }
    ];
  };

  systemd.services.nginx.serviceConfig.SupplementaryGroups = [
    "grafana"
  ];

  services.nginx.virtualHosts.${domain} = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://unix:${config.services.grafana.settings.server.socket}";
      proxyWebsockets = true;
    };
  };
}
