{ config, pkgs, ... }:

{
  services = {
    nginx = {
      enable = true;
      package = pkgs.nginxMainline;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts =
        let
          domain = "ilanjoselevich.com";
          base = locations: {
            inherit locations;
            forceSSL = true;
            enableACME = true;
            kTLS = true;
          };
          proxy = port: base {
            "/".proxyPass = "http://127.0.0.1:" + toString port + "/";
          };
        in
        {
          "jellyfin.${domain}" = proxy 8096;
          "git.${domain}" = proxy 3000;
        };
    };
  };
}

