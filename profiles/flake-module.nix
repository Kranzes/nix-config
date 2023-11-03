{ inputs, ... }:

{
  flake.nixosModules = {
    agenix = import ./agenix.nix { inherit inputs; };
    android = ./android.nix;
    audio = ./audio.nix;
    docs = ./docs.nix;
    grafana-agent = ./grafana-agent.nix;
    impermanence = import ./impermanence.nix { inherit inputs; };
    laptop = ./laptop.nix;
    misc = ./misc.nix;
    nginx = ./nginx.nix;
    nix-nixpkgs = import ./nix-nixpkgs.nix { inherit inputs; };
    opengl = ./opengl.nix;
    security = ./security.nix;
    ssh = ./ssh.nix;
    tailscale = ./tailscale.nix;
    users = ./users.nix;
    xserver = ./xserver.nix;
  };
} 
