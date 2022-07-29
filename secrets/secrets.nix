let
  systems = {
    pongo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMZiUguDNKZlxJpDmuN4Z2AAK9iH9oQLqMQpvo7RZ4q+";
  };
  users = {
    kranzes-yk5 = "age1yubikey1q2nnp3j3umru793y4rz662e0sgcgf69v3900s6gdntwxxrwle5hkwcss32k";
    kranzes-yk5c = "age1yubikey1qwfyruye5pqywhekru234lhaahwpfwmmhf6xesr6yla3zmf0m0u5jmqft80";
  };
  allSystems = builtins.attrValues systems;
  allUsers = builtins.attrValues users;
in
{
  "nextcloud-db-pass.age".publicKeys = allUsers ++ [ systems.pongo ];
  "nextcloud-admin-root-pass.age".publicKeys = allUsers ++ [ systems.pongo ];
}
