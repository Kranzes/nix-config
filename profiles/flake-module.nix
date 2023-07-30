{ inputs, ... }:

{
  flake.nixosModules = {
    agenix = import ./agenix.nix { inherit inputs; };
    android = ./android.nix;
    audio = ./audio.nix;
    docs = ./docs.nix;
    impermanence = import ./impermanence.nix { inherit inputs; };
    laptop = ./laptop.nix;
    misc = ./misc.nix;
    nginx = ./nginx.nix;
    nix-nixpkgs = import ./nix-nixpkgs.nix { inherit inputs; };
    opengl = ./opengl.nix;
    security = ./security.nix;
    ssh = ./ssh.nix;
    tailscale = import ./tailscale.nix { inherit inputs; };
    users = ./users.nix;
    xserver = ./xserver.nix;
  };
} 
