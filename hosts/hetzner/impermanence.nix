{ config, inputs, ... }:

{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  environment.persistence."/nix/persistent" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/systemd/coredump"
    ];
    files = [
      "/etc/machine-id"
    ]
    ++ builtins.concatMap (key: [ key.path (key.path + ".pub") ]) config.services.openssh.hostKeys;
  };

  age.identityPaths = [ "/nix/persistent/etc/ssh/ssh_host_ed25519_key" ];
}
