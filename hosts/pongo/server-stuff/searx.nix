{ config, pkgs, ... }:

{
  services.searx = {
    enable = true;
    settings = {
      use_default_settings = true;
      general.debug = false;
      server.secret_key = "3zEraCmMG9rT6PhS12jnqct9qZwl2yiKM8T99dWSgHKHFmesTHinwPoemXnpTLb5CYbUAj9IpC6Pvh17";
    };
  };

  networking.firewall.allowedUDPPorts = [ 8888 ];
  networking.firewall.allowedTCPPorts = [ 8888 ];
}

