let
  systems = {
    pongo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOq0cqSiwsTj1ktlr70ToobLXD9JIRQynTuOpmwpYilB";
    pan = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGDbBEzvhMeRzkGHpV+rd8Jq8O3hHBQYQhuzpvep08Ux";
    gorilla = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKjg+i3lXnTMb/jGlsbguKdCsrz3M6zmDRd/NheBnUoT";
    hetzner = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILL1Ae0IWUaynCv2AaWxh2U2EDeDrD9ADPpI6O3nu3D0";
  };
  users = {
    kranzes-yk5 = "age1yubikey1qgmx6kq5upm2hkzhlpaj5q6yj2d4h02r5f9tdjv9y9yja4xq4wa5k42ae6d";
    kranzes-yk5c = "age1yubikey1qfejptxfycw5ft2lt388y9eqrjxsk0eqqz3ud4ad87rtvq5qzrzljjruft2";
  };
  allUsers = builtins.attrValues users;
in
{
  # Infra/All
  "infra-tailscaleAuthKey.age".publicKeys = allUsers ++ (with systems; [ pongo pan hetzner gorilla ]);
  "herculesSecrets.age".publicKeys = allUsers ++ (with systems; [ hetzner ]);
  # Pongo
  "nextcloud-admin-root-pass.age".publicKeys = allUsers ++ [ systems.pongo ];
  # Hetzner
  "hetzner-herculesClusterJoinToken.age".publicKeys = allUsers ++ [ systems.hetzner ];
}
