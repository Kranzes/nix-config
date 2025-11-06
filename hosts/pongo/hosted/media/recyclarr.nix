{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.recyclarr = {
    enable = true;
    configuration = lib.importJSON ./recyclarr.json;
  };

  # TODO: Upstream at some point
  systemd.services.recyclarr.preStart = lib.mkForce "";
  systemd.tmpfiles.settings.recyclarr = {
    "/var/lib/recyclarr/config.json"."L+".argument = toString (
      pkgs.runCommand "config.json" { } ''
        cp ${(pkgs.formats.yaml { }).generate "config.json" config.services.recyclarr.configuration} $out
        sed -i -e "s/'\!\([a-z_]\+\) \(.*\)'/\!\1 \2/;s/^\!\!/\!/;" $out
      ''
    );
  };

  age.secrets.recyclarr-secrets = {
    file = ../../../../secrets/pongo-recyclarr-secrets.age;
    path = "/var/lib/recyclarr/secrets.yml";
    owner = config.services.recyclarr.user;
    inherit (config.services.recyclarr) group;
  };
}
