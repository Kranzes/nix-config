{ pkgs, config, ... }:

{
  users.users.seerr = {
    isSystemUser = true;
    group = "seerr";
  };
  users.groups.seerr = { };

  services.seerr = {
    enable = true;
    package = pkgs.seerr.overrideAttrs (old: rec {
      version = "feat-oidc+jellyfin-quickconnect"; # TODO: https://github.com/seerr-team/seerr/discussions/1529

      src = pkgs.fetchFromGitHub {
        owner = "v3DJG6GL";
        repo = "seerr";
        rev = "2ece4e5b6e95bfad7db7ebb6f71eb19924041d94";
        hash = "sha256-8kPqk0SWbtfHZid4K77kcVV14v/HLOe2rz3vokQ7YI4=";
      };

      pnpmDeps = pkgs.fetchPnpmDeps {
        inherit (old) pname;
        inherit version src;
        pnpm = pkgs.pnpm_10.override { nodejs = pkgs.nodejs_22; };
        fetcherVersion = 3;
        hash = "sha256-GzKG6ZbkWA5qa4sGVAS2g4LtnFVUI1JebYImyAVQJyM=";
      };
    });
  };

  systemd.services.seerr = {
    serviceConfig.User = "seerr";
    environment = {
      DB_TYPE = "postgres";
      DB_HOST = "/run/postgresql";
    };
  };

  services.postgresql = {
    ensureDatabases = [ "seerr" ];
    ensureUsers = [
      {
        name = config.systemd.services.seerr.serviceConfig.User;
        ensureDBOwnership = true;
      }
    ];
  };

  services.nginx.virtualHosts."seerr.ilanjoselevich.com" = {
    forceSSL = true;
    enableACME = true;
    locations."/".proxyPass = "http://127.0.0.1:${toString config.services.seerr.port}";
  };
}
