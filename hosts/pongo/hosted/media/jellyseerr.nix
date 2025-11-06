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
      version = "preview-OIDC"; # TODO: https://github.com/seerr-team/seerr/pull/1505

      src = pkgs.fetchFromGitHub {
        owner = "fallenbagel";
        repo = "jellyseerr";
        tag = version;
        hash = "sha256-EJz1W7ewEczizNRs/X3esjQUwJiTHruo7nkAzyKZbjc=";
      };

      pnpmDeps = (pkgs.pnpm_9.override { nodejs = pkgs.nodejs_22; }).fetchDeps {
        inherit (old) pname;
        inherit version src;
        fetcherVersion = 1;
        hash = "sha256-yjrlZfObAMj9WOywlsP51wNrbUNh8m1RxtbkjasnEW4=";
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
    enable = true;
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
