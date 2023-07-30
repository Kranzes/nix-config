{ inputs, ... }:

{ config, ... }:

{
  imports = [
    inputs.agenix.nixosModules.age
    inputs.agenix-rekey.nixosModules.agenixRekey
  ];

  age.rekey = {
    hostPubkey = "${inputs.self}/hosts/${config.networking.hostName}/hostKey.pub";
    masterIdentities = [ ./yubikey-5.pub ];
    extraEncryptionPubkeys = [ ./yubikey-5c.pub ];
  };
}
