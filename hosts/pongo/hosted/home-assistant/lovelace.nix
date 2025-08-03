{
  pkgs,
  config,
  lib,
  ...
}:
{
  services.home-assistant = {
    customLovelaceModules = with pkgs.home-assistant-custom-lovelace-modules; [
      custom-sidebar
      mushroom
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
