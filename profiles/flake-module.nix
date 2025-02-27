{ lib, inputs, ... }:

{
  flake.nixosModules = {
    profiles-agenix = lib.modules.importApply ./agenix.nix { inherit inputs; };
    profiles-android = ./android.nix;
    profiles-audio = ./audio.nix;
    profiles-cachix-deploy = ./cachix-deploy.nix;
    profiles-docs = ./docs.nix;
    profiles-laptop = ./laptop.nix;
    profiles-misc = ./misc.nix;
    profiles-nix-nixpkgs = lib.modules.importApply ./nix-nixpkgs.nix { inherit inputs; };
    profiles-security = ./security.nix;
    profiles-ssh = lib.modules.importApply ./ssh.nix { inherit inputs; };
    profiles-tailscale = ./tailscale.nix;
    profiles-users = ./users.nix;
    profiles-xserver = ./xserver.nix;
  };
}
