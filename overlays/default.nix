{ inputs }:

final: prev: {
  bspswallow = prev.callPackage ./bspswallow { };
  rofi-mpd = prev.callPackage ./rofi-mpd { };
}
