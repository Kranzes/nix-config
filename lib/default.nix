{ inputs, ... }:

{
  flake.lib = {
    mkSystem = import ./mkSystem.nix inputs;
  };
}
