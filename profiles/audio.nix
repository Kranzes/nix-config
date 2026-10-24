{
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
        actions.update-props."latency.internal.ns" = 200000000;
      }
    ];
  };
}
