{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.espanso;

  varType = with types;
    attrsOf (submodule {
      type = mkOption { type = str; };
      params = mkOption { type = with types; attr; };
    });
  simpleMatches = listToAttrs (attrsets.mapAttrsToList
    (trigger: match: {
      name = "espanso/user/${trigger}.yml";
      value = {
        text = ''
          name: ${trigger}
          parent: default

          matches:
            - trigger: "${trigger}"
              replace: "${match}"
        '';
      };
    })
    cfg.matches);

  configText = ''
    ${builtins.toJSON (cfg.settings // { auto_restart = false; show_notifications = false; })}
  '';
  merged = { "espanso/default.yml".text = configText; } // simpleMatches;
in
{
  options = {
    services.espanso = {
      enable = mkEnableOption "Espanso text expander";

      settings = mkOption {
        type = types.attrs;
        description =
          "The espanso config file, will be directly mapped to json, so you can use your normal config with this";
        example = {
          matches = [{
            trigger = "ty";
            replace = "thank you";
            word = true;
          }];

        };
      };

      matches = mkOption {
        type = types.attrsOf types.str;
        description =
          "Simple matches, for anything more complex use services.espanso.settings";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.espanso;
        defaultText = literalExample "pkgs.espanso";
        description = "Espanso package to use";
      };
    };
  };

  config = mkIf cfg.enable {

    home.packages = [ cfg.package ];

    xdg.configFile = merged;

    systemd.user.services.espanso = {
      Unit = {
        Description = "Espanso text expander";
        After = [ "graphical-session-pre.target" "polybar.service" ];
        PartOf = [ "graphical-session.target" ];
      };

      Install = { WantedBy = [ "graphical-session.target" ]; };

      Service = {
        ExecStart = "${cfg.package}/bin/espanso daemon";
        ExecStop = "${cfg.package}/bin/espanso stop";
        Restart = "always";
        RestartSec = 3;
      };
    };
  };
}
