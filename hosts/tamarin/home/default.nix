{
  # Overrides.
  home-manager.users.kranzes = {
    imports = [
      ./ssh-tpm-agent.nix
    ];

    wayland.windowManager.hyprland.settings = {
      monitor = [
        {
          output = "eDP-1";
          mode = "highres";
          position = "auto";
          scale = 1.5;
        }
      ];
      device = [
        {
          # Keep mouse accel for Framework touchpad.
          name = "pixa3854:00-093a:0274-touchpad";
          accel_profile = "adaptive";
        }
      ];
    };
  };
}
