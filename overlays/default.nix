{ inputs }:

final: prev: {
  bspswallow = prev.callPackage ./bspswallow { };
  rofi-mpd = prev.callPackage ./rofi-mpd { };
  rnix-lsp = inputs.rnix-lsp.defaultPackage.x86_64-linux;
}
