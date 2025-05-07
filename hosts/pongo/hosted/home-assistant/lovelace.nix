{ pkgs, ... }:
{
  services.home-assistant = {
    customLovelaceModules = with pkgs.home-assistant-custom-lovelace-modules; [
      mini-graph-card
    ];
    lovelaceConfig = {
      views = [
        {
          title = "Bedroom";
          icon = "mdi:bed";
          cards = [
            {
              name = "Temperature";
              type = "custom:mini-graph-card";
              hour24 = true;
              entities = [
                {
                  entity = "sensor.everything_presence_one_bedroom_temperature";
                  name = "Indoor";
                }
                {
                  entity = "weather.forecast_home";
                  attribute = "temperature";
                  name = "Outdoor";
                }
              ];
            }
          ];
        }
      ];
    };
  };
}
