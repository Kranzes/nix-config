{ writeShellApplication, fetchurl, xorg }:

writeShellApplication {
  name = "bspswallow";
  runtimeInputs = [ xorg.xprop ];
  text = (builtins.readFile ./bspswallow);
}
