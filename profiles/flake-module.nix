{ inputs, ... }:

{
  flake.nixosModules = {
    profiles-agenix = import ./agenix.nix { inherit inputs; };
    profiles-android = ./android.nix;
    profiles-audio = ./audio.nix;
    profiles-cachix-deploy = ./cachix-deploy.nix;
    profiles-docs = ./docs.nix;
    profiles-impermanence = import ./impermanence.nix { inherit inputs; };
    profiles-laptop = ./laptop.nix;
    profiles-misc = ./misc.nix;
    profiles-nix-nixpkgs = import ./nix-nixpkgs.nix { inherit inputs; };
    profiles-opengl = ./opengl.nix;
    profiles-security = ./security.nix;
    profiles-ssh = ./ssh.nix;
    profiles-tailscale = ./tailscale.nix;
    profiles-users = ./users.nix;
    profiles-xserver = ./xserver.nix;
  };
} 
