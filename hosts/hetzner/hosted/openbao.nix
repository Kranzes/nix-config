{ config, ... }:
let
  domain = "secret.ilanjoselevich.com";
in
{
  services.openbao = {
    enable = true;
    settings = {
      ui = true;

      listener.default = {
        type = "tcp";
        tls_acme_email = config.security.acme.defaults.email;
        tls_acme_domains = [ domain ];
        tls_acme_disable_http_challenge = true;
        proxy_protocol_behavior = "use_always";
      };

      cluster_addr = "http://127.0.0.1:8201"; # Not doing actual clustering yet.
      api_addr = "https://${domain}";

      storage.raft.path = "/var/lib/openbao";
    };
  };

  services.nginx = {
    # Needed in order to make OpenBao handle the TLS termination.
    defaultSSLListenPort = 4443;
    streamConfig = ''
      server {
        listen 443;
        listen [::]:443;
        ssl_preread on;
        pass 127.0.0.1:${toString config.services.nginx.defaultSSLListenPort};
      }

      server {
        listen 443;
        listen [::]:443;
        ssl_preread on;
        server_name ${domain};
        proxy_protocol on;
        proxy_pass ${config.services.openbao.settings.listener.default.address};
      }
    '';
  };
}
