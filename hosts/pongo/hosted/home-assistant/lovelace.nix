{
  pkgs,
  config,
  lib,
  ...
}:
{
  services.home-assistant = {
    customLovelaceModules = with pkgs.home-assistant-custom-lovelace-modules; [
      (mushroom.overrideAttrs {
        patches = [
          (pkgs.fetchpatch {
            name = "modernize thermostat auto and heat/cool icon";
            url = "https://github.com/piitaya/lovelace-mushroom/commit/80301c2d9a029d3b8749b186f8159d8588053247.patch";
            hash = "sha256-iv/NeVDopap9C205U/ISNs52ed3LLidgU2vMOe0Fj0I=";
          })
        ];
      })
    ];
  };

  systemd.services.home-assistant.reloadTriggers = lib.concatMap (lib.mapAttrsToList (
    _: o: o.argument
  )) (lib.attrValues config.systemd.tmpfiles.settings.home-assistant);
  systemd.tmpfiles.settings.home-assistant = {
    "${config.services.home-assistant.configDir}/www/sidebar-config.yaml"."L+".argument = toString (
      (pkgs.formats.yaml { }).generate "sidebar-config.yaml" {
        sidebar_editable = false;
        # These only apply to non admins, for admins the defaults are fine.
        order = [
          {
            item = "logbook";
            hide = true;
          }
          {
            item = "history";
            hide = true;
          }
          {
            item = "app settings";
            bottom = true;
          }
        ];
        exceptions = [ { is_admin = true; } ];
      }
    );
  };
}
