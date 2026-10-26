{ inputs, ... }:
{ pkgs, ... }:

let
  inherit (inputs.self.packages.${pkgs.stdenv.hostPlatform.system}) btd700-control btd700ctl;
in

{
  environment.systemPackages = [ btd700-control ];
  services.udev.packages = [
    btd700-control
    btd700ctl
  ];

  systemd.packages = [ btd700ctl ];
  systemd.user.services.btd700d = {
    wantedBy = [ "default.target" ];
    bindsTo = [ "dev-btd700.device" ];
    after = [ "dev-btd700.device" ];
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    extraConfig.pipewire."10-allowed-rates"."context.properties"."default.clock.allowed-rates" = [
      44100
      48000
      88200
      96000
    ];
    # Compensate BTD 700 -> HDB 630 aptX Adaptive (High Quality mode) lag
    wireplumber.extraConfig."50-btd700-latency"."monitor.alsa.rules" = [
      {
        matches = [ { "node.name" = "~alsa_output.usb-Sennheiser_BTD_700_.*"; } ];
        actions.update-props."latency.internal.ns" = 250000000;
      }
    ];
  };
}
