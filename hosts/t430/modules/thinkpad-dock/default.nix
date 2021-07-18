{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.hardware.thinkpad-dock;
  acpiEvent = pkgs.callPackage ./acpi_event.nix {
     inherit (cfg) environment dockEvent undockEvent;
  };
in {
  options.hardware.thinkpad-dock = {
    enable = mkEnableOption "Register ThinkPad ACPI event handler for dock";

    environment = mkOption {
      default = "";
      example = ''
        export DISPLAY=:0
        export XAUTHORITY=/home/user/.Xauthority
      '';
      type = types.str;
      description = "Bash script for environment variables.";
    };

    dockEvent = mkOption {
      default = "";
      example = ''
        $\{pkgs.xorg.xrandr\}/bin/xrandr --output DP-2-1 --mode 1920x1080 --right-of eDP-1
      '';
      type = types.str;
      description = "Bash script to be executed on docking.";
    };

    undockEvent = mkOption {
      default = "";
      example = ''
        $\{pkgs.xorg.xrandr\}/bin/xrandr --output DP-2-1 --off
      '';
      type = types.str;
      description = "Bash script to be executed on undocking.";
    };
  };

  config = mkIf cfg.enable {
    services.acpid = {
      enable = true;

      handlers.thinkpadDock = {
        event = "ibm/hotkey";
        action = builtins.readFile acpiEvent;
      };
    };
  };
}
