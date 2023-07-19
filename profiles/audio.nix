{
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  hardware.pulseaudio.enable = false;

  sound.enable = false;
}
