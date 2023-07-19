{ inputs, ... }:

{
  flake.nixosModules = {
    android = import ./android.nix;
    audio = import ./audio.nix;
    docs = import ./docs.nix;
    laptop = import ./laptop.nix;
    misc = import ./misc.nix;
    nix-nixpkgs = import ./nix-nixpkgs.nix { inherit inputs; };
    opengl = import ./opengl.nix;
    security = import ./security.nix;
    ssh = import ./ssh.nix;
    tailscale = import ./tailscale.nix { inherit inputs; };
    users = import ./users.nix;
    xserver = import ./xserver.nix;
  };
} 
