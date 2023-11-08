{
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedBrotliSettings = true;
    recommendedZstdSettings = true;
    commonHttpConfig = "access_log syslog:server=unix:/dev/log;"; # Send access_log to to journal.
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "personal@ilanjoselevich.com";
  };

  networking.firewall.allowedTCPPorts = [
    80 # HTTP
    443 # HTTPS
  ];
}
