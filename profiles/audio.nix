{
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    extraConfig.pipewire."10-allowed-rates"."context.properties"."default.clock.allowed-rates" = [
      44100
      48000
      96000
    ];
  };
}
