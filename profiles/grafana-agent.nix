{ config, lib, ... }:

{
  services.grafana-agent = {
    enable = true;
    settings.logs.configs = [{
      name = "logging";
      clients = [{ url = "http://pongo:3100/loki/api/v1/push"; }];
      positions.filename = "\${STATE_DIRECTORY}/loki_positions.yaml";
      scrape_configs = [{
        job_name = "journal";
        journal = {
          max_age = "12h";
          labels = {
            host = config.networking.hostName;
            job = "systemd-journal";
          };
        };
        relabel_configs = lib.mapAttrsToList
          (source: target: {
            source_labels = lib.singleton source;
            target_label = target;
          })
          {
            "__journal__systemd_unit" = "systemd_unit";
            "__journal__systemd_user_unit" = "systemd_user_unit";
          };
      }];
    }];
  };
}
