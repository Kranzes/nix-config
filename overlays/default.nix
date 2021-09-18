{ inputs }:

final: prev: {
  bspswallow = prev.callPackage ./bspswallow { };
  rofi-mpd = prev.callPackage ./rofi-mpd { };
  rnix-lsp = inputs.rnix-lsp.defaultPackage.x86_64-linux;
  nixUnstable = prev.nixUnstable.override { patches = [ ../patches/unset-is-macho.patch ]; };
  nix-direnv = prev.nix-direnv.override { inherit (final) nixUnstable; };
}
