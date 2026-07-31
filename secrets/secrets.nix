let
  systems = {
    pongo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOq0cqSiwsTj1ktlr70ToobLXD9JIRQynTuOpmwpYilB";
    tamarin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBMnniv4FFVWUhLDU1u3pSvmSQ3NrvdHpP/kOVW7hw6X";
    hetzner = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGrnR6feQwB8GCASDES3hujWI4fZBtbBbwWf7Hrq8Aon";
  };
  users = {
    kranzes-yk5 = "age1yubikey1qgmx6kq5upm2hkzhlpaj5q6yj2d4h02r5f9tdjv9y9yja4xq4wa5k42ae6d";
    kranzes-yk5c = "age1yubikey1qfejptxfycw5ft2lt388y9eqrjxsk0eqqz3ud4ad87rtvq5qzrzljjruft2";
  };
  allUsers = builtins.attrValues users;
in
{
  # Pongo
  "pongo-openbao-secret-id.age".publicKeys = allUsers ++ [ systems.pongo ];
  # Tamarin
  "tamarin-openbao-secret-id.age".publicKeys = allUsers ++ [ systems.tamarin ];
  # Hetzner
  "hetzner-openbao-secret-id.age".publicKeys = allUsers ++ [ systems.hetzner ];
}
