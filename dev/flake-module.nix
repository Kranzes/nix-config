{
  inputs,
  withSystem,
  config,
  lib,
  ...
}:

{
  imports = [
    inputs.hercules-ci-effects.flakeModule
    inputs.treefmt-nix.flakeModule
  ];

  perSystem =
    {
      pkgs,
      lib,
      inputs',
      ...
    }:
    {
      devShells.default = pkgs.mkShellNoCC {
        packages = [
          inputs'.agenix.packages.agenix
          pkgs.age-plugin-yubikey
        ];
      };

      treefmt = {
        projectRootFile = "flake.nix";
        programs = {
          nixfmt.enable = true;
          deadnix.enable = true;
          statix.enable = true;
        };
      };

      apps = lib.mapAttrs' (host: cfg: {
        name = "deploy-${host}";
        value.program =
          let
            args =
              [
                "-L"
                "--log-format"
                "multiline-with-logs"
                "-s"
                "--no-reexec"
                "--flake"
                "${inputs.self}#${host}"
                "--sudo"
                "--target-host"
                "${cfg.config.networking.hostName}"
              ]
              ++ lib.optionals (host == "pongo") [
                "--build-host"
                "${cfg.config.networking.hostName}"
              ]
              ++ lib.optional cfg.config.security.sudo.wheelNeedsPassword "--ask-sudo-password";
          in
          toString (
            pkgs.writeShellScript "deploy-${host}" ''
              if [[ -n "$1" ]]; then
                TASK="$1"
              else
                TASK="switch"
              fi
              set -x
              ${lib.getExe cfg.config.system.build.nixos-rebuild} "$TASK" ${lib.escapeShellArgs args}
            ''
          );
      }) inputs.self.nixosConfigurations;
    };

  herculesCI = herculesCI: {
    onPush.default.outputs.effects.cachix-deploy = withSystem config.defaultEffectSystem (
      { hci-effects, ... }:
      hci-effects.runIf (herculesCI.config.repo.branch == "master") (
        hci-effects.runCachixDeploy {
          deploy = {
            agents = lib.mapAttrs (_: x: x.config.system.build.toplevel) inputs.self.nixosConfigurations;
            rollbackScript = lib.genAttrs config.systems (
              lib.flip withSystem (
                { pkgs, ... }:
                pkgs.writeShellScript "cachix-deploy-rollback-script" ''
                  echo "Checking if tailscale is still running..."
                  status=$(${lib.getExe pkgs.tailscale} status --json | ${lib.getExe pkgs.jq} -r ".BackendState")
                  if [[ "$status" == "Running" ]]; then
                    echo "Tailscale is running, not rolling back."
                    exit 0
                  else
                    echo "Tailscale is not running, rolling back."
                    exit 1
                  fi
                ''
              )
            );
          };
          async = true;
        }
      )
    );
  };
}
