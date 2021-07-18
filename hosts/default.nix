{ ... }@inputs:
let
  mkSystem = name: channel:
    inputs."nixpkgs-${channel}".lib.nixosSystem {
      extraArgs = inputs;

      system = "x86_64-linux";

      modules = [
        (./. + "/${name}/configuration.nix")
        (./. + "/${name}/hardware-configuration.nix")
        inputs."home-manager-${channel}".nixosModule
      ];
    };
in
{
  desktop = mkSystem "desktop" "unstable";
  t430 = mkSystem "t430" "2105";
}
