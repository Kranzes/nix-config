{ config, pkgs, ... }:

{
  services.nginx.virtualHosts."ilanjoselevich.com" = {
    enableACME = true;
    forceSSL = true;
    root = "/var/www/ilanjoselevich.com";
    locations."/android/".extraConfig = ''
      autoindex on;
      autoindex_localtime on;
    '';
  };
}
