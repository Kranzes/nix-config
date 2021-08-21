{ inputs }:

final: prev: {
  bspswallow = prev.callPackage ./bspswallow { };
  rnix-lsp = inputs.rnix-lsp.defaultPackage.x86_64-linux;
}
