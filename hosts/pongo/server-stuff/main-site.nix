{ config, pkgs, ... }:

{
  services.nginx.virtualHosts."ilanjoselevich.com" = {
    forceSSL = true;
    enableACME = true;
    root = "/var/www/ilanjoselevich.com";
  };
}
