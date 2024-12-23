{ inputs, ... }:

{
  imports = [
    inputs.srvos.nixosModules.mixins-nginx
  ];

  security.acme = {
    acceptTerms = true;
    defaults.email = "personal@ilanjoselevich.com";
  };
}
