{ lib, inputs, ... }:

{
  flake.nixosModules = {
    profiles-android = ./android.nix;
    profiles-audio = ./audio.nix;
    profiles-docs = ./docs.nix;
    profiles-hyprland = ./hyprland.nix;
    profiles-laptop = ./laptop.nix;
    profiles-misc = ./misc.nix;
    profiles-networking = lib.modules.importApply ./networking.nix { inherit inputs; };
    profiles-nix-nixpkgs = lib.modules.importApply ./nix-nixpkgs.nix { inherit inputs; };
    profiles-security = ./security.nix;
    profiles-ssh = lib.modules.importApply ./ssh.nix { inherit inputs; };
    profiles-systemd-creds-openbao = lib.modules.importApply ./systemd-creds-openbao.nix {
      inherit inputs;
    };
    profiles-tailscale = ./tailscale.nix;
    profiles-users = ./users.nix;
  };
}
