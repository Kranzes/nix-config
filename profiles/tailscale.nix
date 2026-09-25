{
  lib,
  config,
  pkgs,
  ...
}:

let
  tag = "tag:infra";
  clientId = "Tp1tNzmaRH11CNTRL-kvM56SjamK11CNTRL?ephemeral=false";
in
{

  services.tailscale = {
    enable = true;
    useRoutingFeatures = lib.mkDefault "client";
    extraUpFlags = [
      "--advertise-tags=${tag}"
      "--client-id=${clientId}"
      "--id-token=file:/run/credentials/tailscaled-autoconnect.service/id-token"
    ]
    ++ lib.optional (lib.elem config.services.tailscale.useRoutingFeatures [
      "both"
      "server"
    ]) "--advertise-exit-node";
    authKeyFile = pkgs.emptyFile; # This option has to be set, even though we don't actually use it.
  };

  services.systemd-creds-openbao.settings.credentials = [
    {
      unit = "tailscaled-autoconnect.service";
      credential = "id-token";
      backend = "raw";
      path = "identity/oidc/token/tailscale";
      field = "token";
    }
  ];

  systemd.services.tailscaled-autoconnect = {
    wantedBy = lib.mkForce [ "tailscaled.service" ];
    wants = [ "systemd-creds-openbao.service" ];
    after = [ "systemd-creds-openbao.service" ];

    serviceConfig.LoadCredential = [
      "id-token:${config.services.systemd-creds-openbao.socketPath}"
    ];
  };
}
