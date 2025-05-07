{
  services.home-assistant.config."automation manual" = [
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
            name = "Catppuccin Macchiato";
            mode = "dark";
          };
        }
        {
          service = "frontend.set_theme";
          data = {
            name = "Catppuccin Latte";
            mode = "light";
          };
        }
      ];
    }

  ];
}
