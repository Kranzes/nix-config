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
      version = "preview-new-oidc"; # TODO: https://github.com/seerr-team/seerr/pull/2715

      src = pkgs.fetchFromGitHub {
        owner = "seerr-team";
        repo = "seerr";
        rev = "0bfd615c0dcd13b30b15bdf0aa98e23669f55cd2";
        hash = "sha256-YPpicQlArAqWnRbUbtUYlwTJk0AGxcaeQmaYNT0vogo=";
      };

      pnpmDeps = pkgs.fetchPnpmDeps {
        inherit (old) pname;
        inherit version src;
        pnpm = pkgs.pnpm_10.override { nodejs-slim = pkgs.nodejs-slim_22; };
        fetcherVersion = 3;
        hash = "sha256-7nBkeXGJfDRSvNesOjOK+Mtzp6SlBvbytyfsQl9eh/Y=";
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
