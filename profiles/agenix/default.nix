{ inputs, ... }:

{ pkgs, lib, config, options, ... }:

{
  imports = [
    inputs.agenix.nixosModules.age
    inputs.agenix-rekey.nixosModules.agenixRekey
  ];

  age.rekey = {
    hostPubkey = lib.fileContents "${inputs.self}/hosts/${config.networking.hostName}/hostKey.pub";
    masterIdentities = [ ./yubikey-5.pub ];
    extraEncryptionPubkeys = [ ./yubikey-5c.pub ];
  };
}
