{ inputs, ... }:

{
  perSystem = { pkgs, inputs', lib, ... }: {
    devShells.default = pkgs.mkShellNoCC {
      packages = [
        inputs'.agenix.packages.agenix
        pkgs.age-plugin-yubikey
      ];
    };

    apps = lib.mapAttrs'
      (host: cfg: {
        name = "deploy-${host}";
        value.program = toString (pkgs.writeShellScript "deploy-${host}" ''
          if [[ -n "$1" ]]; then 
            TASK="$1" 
          else 
            TASK="switch" 
          fi
          set -x
          NIX_SSHOPTS="-tt" ${lib.getExe (pkgs.nixos-rebuild.override { nix = pkgs.nixUnstable; })} "$TASK" -s --use-remote-sudo --fast --flake ${inputs.self}#${host} \
          --target-host ${cfg.config.networking.hostName} ${lib.optionalString (host == "pongo") "--build-host ${cfg.config.networking.hostName}"}
        '');
      })
      inputs.self.nixosConfigurations;
  };
}
