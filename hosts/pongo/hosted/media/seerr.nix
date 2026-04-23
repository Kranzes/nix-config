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
        rev = "f7da77db218179141ed0d919e7564a0d065cb198";
        hash = "sha256-w7wgTF1xLmx/1Sa3KYuFklma5UpVJyIZfAvGA5uyL+M=";
      };

      pnpmDeps = pkgs.fetchPnpmDeps {
        inherit (old) pname;
        inherit version src;
        pnpm = pkgs.pnpm_10.override { nodejs = pkgs.nodejs_22; };
        fetcherVersion = 3;
        hash = "sha256-88jXwJ4ehrc4OXSAgAcMe+gF+HdwYLFymDye+SWyt5c=";
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
