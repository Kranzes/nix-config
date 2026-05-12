{
  # Overrides.
  home-manager.users.kranzes = {
    imports = [
      ./ssh-tpm-agent.nix
    ];

    wayland.windowManager.hyprland.settings.monitor = ",highres,auto,1.5";
  };
}
