{ pkgs, config, inputs, ... }:

{
  services.tailscale.enable = true;

  systemd.services.tailscaled = {
    restartIfChanged = false;
    serviceConfig.ExecStart = [
      ""
      "${config.services.tailscale.package}/bin/tailscaled --state=mem: --port $PORT $FLAGS"
    ];
  };

  age.secrets.tailscaleAuthKey.file = "${inputs.self}/secrets/infra-tailscaleAuthKey.age";

  systemd.services.tailscaled-autoconnect = {
    description = "Automatic connection to Tailscale";
    after = [ "tailscaled.service" ];
    requires = [ "tailscaled.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      # wait for tailscaled to settle
      sleep 2

      # check if we are already authenticated to tailscale
      status="$(${config.services.tailscale.package}/bin/tailscale status -json | ${pkgs.jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then # if so, then do nothing
        exit 0
      fi

      # otherwise authenticate with tailscale
      ${config.services.tailscale.package}/bin/tailscale up \
        --authkey file:${config.age.secrets.tailscaleAuthKey.path} \
        --hostname=${config.networking.hostName}
    '';
  };
}
