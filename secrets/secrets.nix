let
  systems = {
    pongo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMZiUguDNKZlxJpDmuN4Z2AAK9iH9oQLqMQpvo7RZ4q+";
    pan = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGDbBEzvhMeRzkGHpV+rd8Jq8O3hHBQYQhuzpvep08Ux";
    hetzner = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILL1Ae0IWUaynCv2AaWxh2U2EDeDrD9ADPpI6O3nu3D0";
    oracle = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC6eHn5vFJQ/KwWqT7FMEHroKqFayRRGSi0FpOE7zMwX";
  };
  users = {
    kranzes-yk5 = "age1yubikey1q2nnp3j3umru793y4rz662e0sgcgf69v3900s6gdntwxxrwle5hkwcss32k";
    kranzes-yk5c = "age1yubikey1qwfyruye5pqywhekru234lhaahwpfwmmhf6xesr6yla3zmf0m0u5jmqft80";
  };
  allUsers = builtins.attrValues users;
in
{
  # Infra/All
  "infra-tailscaleAuthKey.age".publicKeys = allUsers ++ (with systems; [ pongo pan hetzner oracle ]);
  "herculesSecrets.age".publicKeys = allUsers ++ (with systems; [ hetzner oracle ]);
  # Pongo
  "nextcloud-db-pass.age".publicKeys = allUsers ++ [ systems.pongo ];
  "nextcloud-admin-root-pass.age".publicKeys = allUsers ++ [ systems.pongo ];
  # Hetzner
  "hetzner-herculesClusterJoinToken.age".publicKeys = allUsers ++ [ systems.hetzner ];
  # Oracle
  "oracle-herculesClusterJoinToken.age".publicKeys = allUsers ++ [ systems.oracle ];
}
