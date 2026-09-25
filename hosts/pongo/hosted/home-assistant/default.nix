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
    url = "https://github.com/catppuccin/home-assistant/raw/b37ada06d011fe02d487719b06e70e98ded76149/themes/catppuccin.yaml";
    hash = "sha256-UI6g9NsziSze5zUGzl2DjgG68R+z7NtV1bC43p1FIVU=";
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
      "smlight"
      "mqtt"
      "cloud"
      "smartthings"
      "matter"
      "energy"
      "roborock"
    ];
    customComponents = with pkgs.home-assistant-custom-components; [
      auth_oidc
      home_connect_alt
      oref_alert
    ];
    config = {
      homeassistant = {
        external_url = "https://${domain}";
        internal_url = "http://127.0.0.1:8123";
        auth_providers = [ ];
        latitude = "!secret homeassistant_latitude";
        longitude = "!secret homeassistant_longitude";
        elevation = "!secret homeassistant_elevation";
        radius = "!secret homeassistant_radius";
      };
      recorder.db_url = "postgresql://@/hass";
      auth_oidc = {
        client_id = "home-assistant";
        discovery_url = "https://idm.ilanjoselevich.com/oauth2/openid/home-assistant/.well-known/openid-configuration";
        client_secret = "!secret auth_oidc_client_secret";
        id_token_signing_alg = "ES256";
        roles.admin = "home-assistant_admins@idm.ilanjoselevich.com";
        display_name = "Kanidm";
        features.force_https = true;
      };
      frontend.themes = "!include ${catppuccin-theme}";
      history = { };
      logbook = { };
      zeroconf = { };
      mobile_app = { };
      cloud = { };
      my = { };
      energy = { };
      "automation ui" = "!include automations.yaml";
      "script ui" = "!include scripts.yaml";
      "scene ui" = "!include scenes.yaml";
    };
  };

  services.postgresql = {
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
      proxyPass = hassCfg.homeassistant.internal_url;
      proxyWebsockets = true;
    };
  };

  systemd.services.home-assistant = {
    wants = [ "systemd-creds-openbao.service" ];
    after = [ "systemd-creds-openbao.service" ];
    serviceConfig.LoadCredential = [
      "secrets.yaml:${config.services.systemd-creds-openbao.socketPath}"
    ];
  };

  systemd.tmpfiles.settings.home-assistant."${config.services.home-assistant.configDir}/secrets.yaml"."L+".argument =
    "/run/credentials/home-assistant.service/secrets.yaml";

  services.restic.backups.default.paths = [
    "${config.services.home-assistant.configDir}/backups"
  ];
}
