{ pkgs, ... }:
let
  catppuccin-macchiato = pkgs.fetchurl {
    name = "homer-catppuccin-macchiato.css";
    url = "https://github.com/mrpbennett/catppuccin-homer/raw/fd4eab5387aa44e3fc95a830280282bda3dbff54/flavours/catppuccin-macchiato.css";
    hash = "sha256-ehOpdSNo2suVfUxej70dF6iOJdrbtJbjI7ucA+bvxnM=";
  };

  homerConfig = {
    header = false;
    footer = false;
    documentTitle = "portal.ilanjoselevich.com";
    stylesheet = [ "assets/catppuccin-macchiato.css" ];
    defaults = {
      colorTheme = "dark";
      layout = "list";
    };
    links = [
      {
        name = "nix-config";
        icon = "fab fa-github";
        url = "https://github.com/Kranzes/nix-config";
        target = "_top";
      }
    ];
    services = [
      {
        items = [
          {
            name = "Kanidm";
            subtitle = "idm.ilanjoselevich.com";
            logo = "https://github.com/kanidm/kanidm/raw/refs/heads/master/artwork/logo-square.svg";
            url = "https://idm.ilanjoselevich.com";
            endpoint = "https://idm.ilanjoselevich.com/status";
            type = "Ping";
            target = "_top";
          }
          {
            name = "Grafana";
            subtitle = "monitoring.ilanjoselevich.com";
            logo = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/svg/grafana.svg";
            url = "https://monitoring.ilanjoselevich.com";
            endpoint = "https://monitoring.ilanjoselevich.com/healthz";
            type = "Ping";
            target = "_top";
          }
          {
            name = "Nextcloud";
            subtitle = "cloud.ilanjoselevich.com";
            logo = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/svg/nextcloud.svg";
            url = "https://cloud.ilanjoselevich.com";
            endpoint = "https://cloud.ilanjoselevich.com/status.php";
            type = "Ping";
            target = "_top";
          }
          {
            name = "Jellyfin";
            subtitle = "jellyfin.ilanjoselevich.com";
            logo = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/svg/jellyfin.svg";
            url = "https://jellyfin.ilanjoselevich.com";
            endpoint = "https://jellyfin.ilanjoselevich.com/health";
            type = "Ping";
            target = "_top";
          }
          {
            name = "Home Assistant";
            subtitle = "home.ilanjoselevich.com";
            logo = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/svg/home-assistant.svg";
            url = "https://home.ilanjoselevich.com";
            endpoint = "https://home.ilanjoselevich.com/manifest.json";
            method = "get";
            type = "Ping";
            target = "_top";
          }
        ];
      }
    ];
  };
in
{
  services.nginx.virtualHosts."portal.ilanjoselevich.com" = {
    forceSSL = true;
    enableACME = true;
    locations = {
      "/".root = pkgs.homer;
      "=/assets/config.yml".alias = (pkgs.formats.yaml { }).generate "homer-config.yml" homerConfig;
      "=/assets/catppuccin-macchiato.css".alias = catppuccin-macchiato;
    };
  };
}
