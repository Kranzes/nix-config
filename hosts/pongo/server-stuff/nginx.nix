{ config, pkgs, ... }:

{

  services = {
    nginx = {
      enable = true;

      clientMaxBodySize = "1g";

      # Use recommended settings
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      # Only allow PFS-enabled ciphers with AES256
      sslCiphers = "AES256+EECDH:AES256+EDH:g!aNULL";

      commonHttpConfig = ''
        map $scheme $hsts_header {
          https   "max-age=31536000; includeSubdomains; preload";
        }
        add_header Strict-Transport-Security $hsts_header;
        add_header 'Referrer-Policy' 'origin-when-cross-origin';
        add_header X-Content-Type-Options nosniff;
        add_header X-XSS-Protection "1; mode=block";
        proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";
      '';

      # Add any further config to match your needs, e.g.:
      virtualHosts =
        let
          base = locations: {
            inherit locations;

            forceSSL = true;
            enableACME = true;
          };
          proxy = port: base {
            "/".proxyPass = "http://127.0.0.1:" + toString (port) + "/";
          };
        in
        {
          "jellyfin.ilanjoselevich.com" = proxy 8096;
          "stats.ilanjoselevich.com" = proxy 19999;
          "git.ilanjoselevich.com" = proxy 3000;
        };
    };
  };


}

