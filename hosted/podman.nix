{
  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true;
    dockerCompat = true;
    autoPrune = {
      enable = true;
      flags = [ "--all" ];
    };
  };
}
