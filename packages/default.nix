{ self, ... }@inputs:

let
  system = "x86_64-linux";
  pkgs = inputs.nixpkgs.legacyPackages.${system};
in

{
  "bspswallow" = pkgs.callPackage "${self}/packages/bspswallow" { };
  "rofi-mpd" = pkgs.callPackage "${self}/packages/rofi-mpd" { };
}
