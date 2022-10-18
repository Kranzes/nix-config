let
  systems = {
    pongo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMZiUguDNKZlxJpDmuN4Z2AAK9iH9oQLqMQpvo7RZ4q+";
    pan = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGDbBEzvhMeRzkGHpV+rd8Jq8O3hHBQYQhuzpvep08Ux";
    vultr = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII+3eMMIFUDkj7J6r1askbB/vSQaLmhb0A661PYAjWsV";
  };
  users = {
    kranzes-yk5 = "age1yubikey1q2nnp3j3umru793y4rz662e0sgcgf69v3900s6gdntwxxrwle5hkwcss32k";
    kranzes-yk5c = "age1yubikey1qwfyruye5pqywhekru234lhaahwpfwmmhf6xesr6yla3zmf0m0u5jmqft80";
  };
  allSystems = builtins.attrValues systems;
  allUsers = builtins.attrValues users;
in
{
  # All
  "herculesBinaryCaches.age".publicKeys = allUsers ++ [ systems.pongo ];
  "herculesSecrets.age".publicKeys = allUsers ++ [ systems.pongo ];
  # Pongo
  "pongo-herculesClusterJoinToken.age".publicKeys = allUsers ++ [ systems.pongo ];
  "pongo-cachix-deploy-agent.age".publicKeys = allUsers ++ [ systems.pongo ];
  "nextcloud-db-pass.age".publicKeys = allUsers ++ [ systems.pongo ];
  "nextcloud-admin-root-pass.age".publicKeys = allUsers ++ [ systems.pongo ];
  # Pan
  "pan-cachix-deploy-agent.age".publicKeys = allUsers ++ [ systems.pan ];
  # Vultr
  "vultr-cachix-deploy-agent.age".publicKeys = allUsers ++ [ systems.vultr ];
}
