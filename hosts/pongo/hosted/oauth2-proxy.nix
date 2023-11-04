{ config, ... }:
let
  domain = "login.ilanjoselevich.com";
in
{
  services.oauth2_proxy = {
    enable = true;
    provider = "oidc";
    clientID = "oauth2-proxy";
    keyFile = config.age.secrets.oauth2-proxy-secret.path;
    email.domains = [ "*" ];
    reverseProxy = true;
    setXauthrequest = true;
    redirectURL = "https://${domain}/oauth2/callback";
    scope = "openid email";
    cookie.domain = ".ilanjoselevich.com";
    extraConfig = {
      oidc-issuer-url = "https://idm.ilanjoselevich.com/oauth2/openid/oauth2-proxy";
      code-challenge-method = "S256";
      skip-provider-button = true;
      whitelist-domain = ".ilanjoselevich.com";
    };
  };

  age.secrets.oauth2-proxy-secret = {
    file = ../../../secrets/${config.networking.hostName}-oauth2-proxy-secret.age;
    group = "oauth2_proxy";
    owner = "oauth2_proxy";
  };

  services.nginx = {
    enable = true;
    virtualHosts.${domain} = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = config.services.oauth2_proxy.httpAddress;
    };
  };

  security.acme = {
    acceptTerms = true;
    certs.${domain}.email = "personal@ilanjoselevich.com";
  };
}
