{ pkgs, config, ... }:

{
  users.users.jellyseerr = {
    isSystemUser = true;
    group = "jellyseerr";
  };
  users.groups.jellyseerr = { };

  services.jellyseerr = {
    enable = true;
    package = pkgs.jellyseerr.overrideAttrs (old: rec {
      version = "preview-OIDC"; # TODO: https://github.com/seerr-team/seerr/discussions/1529

      src = pkgs.fetchFromGitHub {
        owner = "fallenbagel";
        repo = "jellyseerr";
        tag = version;
        hash = "sha256-EJz1W7ewEczizNRs/X3esjQUwJiTHruo7nkAzyKZbjc=";
      };

      pnpmDeps = pkgs.fetchPnpmDeps {
        inherit (old) pname;
        inherit version src;
        pnpm = pkgs.pnpm_9.override { nodejs = pkgs.nodejs_22; };
        fetcherVersion = 3;
        hash = "sha256-qv38UGPAqANLr3/MwwF75Vc8x3K5/IyfXnnBhypO7ck=";
      };
    });
  };

  systemd.services.jellyseerr = {
    serviceConfig.User = "jellyseerr";
    environment = {
      DB_TYPE = "postgres";
      DB_HOST = "/run/postgresql";
    };
  };

  services.postgresql = {
    ensureDatabases = [ "jellyseerr" ];
    ensureUsers = [
      {
        name = config.systemd.services.jellyseerr.serviceConfig.User;
        ensureDBOwnership = true;
      }
    ];
  };

  services.nginx.virtualHosts."seerr.ilanjoselevich.com" = {
    forceSSL = true;
    enableACME = true;
    locations."/".proxyPass = "http://127.0.0.1:${toString config.services.jellyseerr.port}";
  };
}
