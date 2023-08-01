{ inputs, ... }:

{ config, ... }:

{
  imports = [
    inputs.agenix.nixosModules.age
    inputs.agenix-rekey.nixosModules.agenixRekey
  ];

  age.rekey = {
    hostPubkey = ../../hosts/${config.networking.hostName}/hostKey.pub;
    # Main for rekeying
    masterIdentities = [ ./yubikey-5.pub ];
    # Backup
    extraEncryptionPubkeys = [
      # YubiKey 5C NFC
      "age1yubikey1qfejptxfycw5ft2lt388y9eqrjxsk0eqqz3ud4ad87rtvq5qzrzljjruft2"
    ];
  };
}
