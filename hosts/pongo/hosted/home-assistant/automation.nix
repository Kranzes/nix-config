{
  services.home-assistant.config = {
    "automation nixos" = [
      {
        alias = "Set the default theme on startup";
        trigger = [
          {
            platform = "homeassistant";
            event = "start";
          }
        ];
        action = [
          {
            service = "frontend.set_theme";
            data = {
              name = "Catppuccin Auto Latte Macchiato";
              mode = "auto";
            };
          }
        ];
      }
    ];
  };
}
