{
  pkgs,
  config,
  ...
}:
{
  services.zigbee2mqtt = {
    enable = true;
    package = pkgs.zigbee2mqtt_2;
    settings = {
      serial = {
        port = "tcp://slzb-06m.local:6638";
        baudrate = 115200;
        adapter = "ember";
      };
      advanced.transmit_power = 20;
      mqtt = {
        server = "mqtt://localhost:1883";
        user = "zigbee2mqtt";
        password = "Y2kqeJEgHDPHSlPHrsysMotMoYmCyJQSUTMSXi3g"; # Secure enough for me.
      };
    };
  };

  services.mosquitto = {
    enable = true;
    listeners = [
      {
        users = {
          ${config.services.zigbee2mqtt.settings.mqtt.user} = {
            acl = [
              "readwrite zigbee2mqtt/#"
              "readwrite homeassistant/#"
            ];
            inherit (config.services.zigbee2mqtt.settings.mqtt) password;
          };
          home-assistant = {
            acl = [
              "readwrite zigbee2mqtt/#"
              "readwrite homeassistant/#"
            ];
            password = "Rc5Pjz4awpx5MstZEfAPgEgaWY7jZNqShKtEqrc3"; # Secure enough for me.
          };
        };
      }
    ];
  };

  services.restic.backups.default.paths = [
    config.services.zigbee2mqtt.dataDir
    config.services.mosquitto.dataDir
  ];
}
