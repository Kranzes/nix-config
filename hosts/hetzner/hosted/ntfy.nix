{ config, ... }:
let
  domain = "push.ilanjoselevich.com";
in
{
  age.secrets = {
    ntfy-sh-firebase-key.file = ../../../secrets/hetzner-ntfy-sh-firebase-key.age;
    grafana-to-ntfy-ntfy-pass.file = ../../../secrets/hetzner-grafana-to-ntfy-ntfy-pass.age;
    grafana-to-ntfy-pass.file = ../../../secrets/hetzner-grafana-to-ntfy-pass.age;
  };

  systemd.services.ntfy-sh.serviceConfig.LoadCredential = [ "firebase-key:${config.age.secrets.ntfy-sh-firebase-key.path}" ];

  services.ntfy-sh = {
    enable = true;
    settings = {
      base-url = "https://${domain}";
      behind-proxy = true;
      web-root = "disable";
      enable-signup = false;
      enable-login = false;
      auth-default-access = "deny-all";
      firebase-key-file = "/run/credentials/ntfy-sh.service/firebase-key";
    };
  };

  services.nginx.virtualHosts.${domain} = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://${config.services.ntfy-sh.settings.listen-http}";
      proxyWebsockets = true;
    };
  };

  services.grafana-to-ntfy = {
    enable = true;
    settings = {
      ntfyUrl = "${config.services.ntfy-sh.settings.base-url}/grafana";
      ntfyBAuthUser = "grafana";
      ntfyBAuthPass = config.age.secrets.grafana-to-ntfy-ntfy-pass.path;
      bauthPass = config.age.secrets.grafana-to-ntfy-pass.path;
    };
  };

  systemd.services.grafana.serviceConfig.LoadCredential = [ "ntfy_password:${config.services.grafana-to-ntfy.settings.bauthPass}" ];

  services.grafana.provision.alerting.contactPoints.settings = {
    apiVersion = 1;
    contactPoints = [{
      orgId = 1;
      name = "ntfy";
      receivers = [{
        uid = "ntfy";
        type = "webhook";
        disableResolveMessage = false;
        settings = {
          url = "http://127.0.0.1:8000";
          httpMethod = "POST";
          username = config.services.grafana-to-ntfy.settings.bauthUser;
          password = "$__file{/run/credentials/grafana.service/ntfy_password}";
        };
      }];
    }];
    deleteContactPoints = [{
      orgId = 1;
      uid = "ntfy";
    }];
  };
}
