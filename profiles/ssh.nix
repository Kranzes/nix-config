{ inputs, ... }:

{
  imports = [
    (inputs.srvos.nixosModules.common + "/openssh.nix")
  ];

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
  };
}
