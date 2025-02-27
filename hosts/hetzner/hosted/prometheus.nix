{ config, pkgs, ... }:
{
  services.prometheus = {
    enable = true;
    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [
          {
            targets = map (h: "${h}:${toString config.services.prometheus.exporters.node.port}") [
              config.networking.hostName
              "pongo"
            ];
          }
        ];
      }
    ];
  };

  services.grafana.provision = {
    datasources.settings = {
      datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          url = "http://127.0.0.1:${toString config.services.prometheus.port}";
          orgId = 1;
        }
      ];
      deleteDatasources = [
        {
          name = "Prometheus";
          orgId = 1;
        }
      ];
    };
    dashboards.settings.providers = [
      {
        name = "Node Exporter Full";
        options.path = pkgs.fetchurl {
          name = "node-exporter-full-37-grafana-dashboard.json";
          url = "https://grafana.com/api/dashboards/1860/revisions/37/download";
          hash = "sha256-1DE1aaanRHHeCOMWDGdOS1wBXxOF84UXAjJzT5Ek6mM=";
        };
        orgId = 1;
      }
    ];
  };
}
