{ inputs, withSystem, config, lib, ... }:

{
  imports = [ inputs.hercules-ci-effects.flakeModule ];

  perSystem = { pkgs, lib, inputs', ... }: {
    devShells.default = pkgs.mkShellNoCC {
      packages = [
        inputs'.agenix.packages.agenix
        pkgs.age-plugin-yubikey
      ];
    };

    apps = (lib.mapAttrs'
      (host: cfg: {
        name = "deploy-${host}";
        value.program = toString (pkgs.writeShellScript "deploy-${host}" ''
          if [[ -n "$1" ]]; then
            TASK="$1"
          else
            TASK="switch"
          fi
          set -x
          ${lib.optionalString cfg.config.security.sudo.wheelNeedsPassword "export NIX_SSHOPTS=-tt"}
          ${lib.getExe (pkgs.nixos-rebuild.override { nix = pkgs.nixUnstable; })} "$TASK" -s --use-remote-sudo --fast --flake ${inputs.self}#${host} \
            --target-host ${cfg.config.networking.hostName} ${lib.optionalString (host == "pongo") "--build-host ${cfg.config.networking.hostName}"}
        '');
      })
      inputs.self.nixosConfigurations);
  };


  herculesCI = herculesCI: {
    onPush.default.outputs.effects.cachix-deploy = withSystem config.defaultEffectSystem ({ hci-effects, ... }:
      hci-effects.runIf (herculesCI.config.repo.branch == "master") (hci-effects.runCachixDeploy {
        deploy.agents = lib.mapAttrs (_: x: x.config.system.build.toplevel) inputs.self.nixosConfigurations;
        async = true;
      })
    );
  };
}
