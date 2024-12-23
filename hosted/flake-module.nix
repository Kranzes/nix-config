{ inputs, lib, ... }:

{
  flake.nixosModules = {
    hosted-nginx = lib.modules.importApply ./nginx.nix { inherit inputs; };
  };
} 
