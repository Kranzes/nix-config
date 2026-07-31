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
  systemd.services.recyclarr = {
    preStart = lib.mkForce "";
    serviceConfig.LoadCredential = [
      "secrets.yml:${config.services.systemd-creds-openbao.socketPath}"
    ];
  };
  systemd.tmpfiles.settings.recyclarr = {
    "/var/lib/recyclarr/config.json"."L+".argument = toString (
      pkgs.runCommand "config.json" { } ''
        cp ${(pkgs.formats.yaml { }).generate "config.json" config.services.recyclarr.configuration} $out
        sed -i -e "s/'\!\([a-z_]\+\) \(.*\)'/\!\1 \2/;s/^\!\!/\!/;" $out
      ''
    );
    "/var/lib/recyclarr/secrets.yml"."L+".argument = "/run/credentials/recyclarr.service/secrets.yml";
  };
}
