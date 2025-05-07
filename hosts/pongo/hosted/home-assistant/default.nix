{
  pkgs,
  config,
  ...
}:
let
  domain = "home.ilanjoselevich.com";
  hassCfg = config.services.home-assistant.config;
  catppuccin-theme = pkgs.fetchurl {
    name = "catppuccin.yaml";
    url = "https://github.com/catppuccin/home-assistant/raw/0277ab8a42751bcf97c49082e4b743ec32304571/themes/catppuccin.yaml";
    hash = "sha256-MkMegPaZIsTVtP6an9dMw7oFQlTlQjHCLg685suyRE4=";
  };
in
{
  imports = [
    ./automation.nix
    ./lovelace.nix
  ];

  services.home-assistant = {
    enable = true;
    extraPackages = ps: with ps; [ psycopg2 ];
    extraComponents = [
      "isal"
      "history"
      "logbook"
      "mobile_app"
      "zeroconf"
      "esphome"
      "met"
    ];
    customComponents = with pkgs.home-assistant-custom-components; [
      auth_oidc
    ];
    config = {
      http = {
        server_host = "127.0.0.1";
        trusted_proxies = [ hassCfg.http.server_host ];
        use_x_forwarded_for = true;
        cors_allowed_origins = [ "https://portal.ilanjoselevich.com" ];
      };
      homeassistant.external_url = "https://${domain}";
      recorder.db_url = "postgresql://@/hass";
      auth_oidc = {
        client_id = "home-assistant";
        discovery_url = "https://idm.ilanjoselevich.com/oauth2/openid/home-assistant/.well-known/openid-configuration";
        client_secret = "!secret auth_oidc_client_secret";
        id_token_signing_alg = "ES256";
        roles.admin = "home-assistant_admins@idm.ilanjoselevich.com";
      };
      frontend.themes = "!include ${catppuccin-theme}";
      history = { };
      logbook = { };
      zeroconf = { };
      mobile_app = { };
    };
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ (baseNameOf hassCfg.recorder.db_url) ];
    ensureUsers = [
      {
        name = config.systemd.services.home-assistant.serviceConfig.User;
        ensureDBOwnership = true;
      }
    ];
  };

  services.nginx.virtualHosts.${domain} = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://${hassCfg.http.server_host}:${toString hassCfg.http.server_port}";
      proxyWebsockets = true;
    };
  };

  age.secrets.home-assistant-secrets = {
    file = ../../../../secrets/pongo-home-assistant-secrets.age;
    path = "${config.services.home-assistant.configDir}/secrets.yaml";
    owner = config.systemd.services.home-assistant.serviceConfig.User;
    group = config.systemd.services.home-assistant.serviceConfig.Group;
  };
}
