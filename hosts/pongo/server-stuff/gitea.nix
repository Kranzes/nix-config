{ config, pkgs, ... }:

{

  services.gitea = {
    enable = true;
    rootUrl = "https://git.ilanjoselevich.com";
    appName = "Ilan's Git";
    settings = { ui = { DEFAULT_THEME = "arc-green"; }; };
  };

  networking.firewall.allowedUDPPorts = [ 3000 ];
  networking.firewall.allowedTCPPorts = [ 3000 ];
}

