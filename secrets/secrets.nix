let
  systems = {
    pongo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOq0cqSiwsTj1ktlr70ToobLXD9JIRQynTuOpmwpYilB";
    gorilla = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJDTblFcEmy7kyJRgZ43BWmNk22TE4N+xyTDeJC7jpwc";
    hetzner = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGrnR6feQwB8GCASDES3hujWI4fZBtbBbwWf7Hrq8Aon";
    pan = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK/SSCGsV61hZy5NVzjeA07PufZIHufUIeCD6id9orKF";
  };
  users = {
    kranzes-yk5 = "age1yubikey1qgmx6kq5upm2hkzhlpaj5q6yj2d4h02r5f9tdjv9y9yja4xq4wa5k42ae6d";
    kranzes-yk5c = "age1yubikey1qfejptxfycw5ft2lt388y9eqrjxsk0eqqz3ud4ad87rtvq5qzrzljjruft2";
  };
  allUsers = builtins.attrValues users;
  allSystems = builtins.attrValues systems;
in
{
  # All
  "all-tailscale-auth-key.age".publicKeys = allUsers ++ allSystems;
  # Pongo
  "pongo-nextcloud-admin-root-pass.age".publicKeys = allUsers ++ [ systems.pongo ];
  "pongo-kranzes-hercules-cluster-join-token.age".publicKeys = allUsers ++ [ systems.pongo ];
  "pongo-kranzes-hercules-secrets.age".publicKeys = allUsers ++ [ systems.pongo ];
  "pongo-kranzes-hercules-binary-caches.age".publicKeys = allUsers ++ [ systems.pongo ];
  "pongo-cachix-deploy-agent.age".publicKeys = allUsers ++ [ systems.pongo ];
  "pongo-home-assistant-secrets.age".publicKeys = allUsers ++ [ systems.pongo ];
  "pongo-restic-default-env-file.age".publicKeys = allUsers ++ [ systems.pongo ];
  "pongo-restic-default-repo-password.age".publicKeys = allUsers ++ [ systems.pongo ];
  # Gorilla
  "gorilla-cachix-deploy-agent.age".publicKeys = allUsers ++ [ systems.gorilla ];
  # Hetzner
  "hetzner-cachix-deploy-agent.age".publicKeys = allUsers ++ [ systems.hetzner ];
  "hetzner-kanidm-provision-extra-json.age".publicKeys = allUsers ++ [ systems.hetzner ];
  "hetzner-kanidm-oauth2-tailscale-basic-secret.age".publicKeys = allUsers ++ [ systems.hetzner ];
  "hetzner-kanidm-oauth2-nextcloud-basic-secret.age".publicKeys = allUsers ++ [ systems.hetzner ];
  "hetzner-kanidm-oauth2-jellyfin-basic-secret.age".publicKeys = allUsers ++ [ systems.hetzner ];
  "hetzner-kanidm-oauth2-grafana-basic-secret.age".publicKeys = allUsers ++ [ systems.hetzner ];
  "hetzner-kanidm-oauth2-home-assistant-basic-secret.age".publicKeys = allUsers ++ [
    systems.hetzner
  ];
  "hetzner-grafana-signing-key.age".publicKeys = allUsers ++ [ systems.hetzner ];
  "hetzner-ntfy-sh-firebase-key.age".publicKeys = allUsers ++ [ systems.hetzner ];
  "hetzner-grafana-to-ntfy-ntfy-pass.age".publicKeys = allUsers ++ [ systems.hetzner ];
  "hetzner-grafana-to-ntfy-pass.age".publicKeys = allUsers ++ [ systems.hetzner ];
  "hetzner-restic-default-env-file.age".publicKeys = allUsers ++ [ systems.hetzner ];
  "hetzner-restic-default-repo-password.age".publicKeys = allUsers ++ [ systems.hetzner ];
  # Pan
  "pan-cachix-deploy-agent.age".publicKeys = allUsers ++ [ systems.pan ];
}
