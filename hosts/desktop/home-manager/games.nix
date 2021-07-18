{ config, pkgs, ... }:

let
  version = "6.12-GE-1";
  source = fetchTarball {
    url =
      "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/Proton-${version}.tar.gz";
    sha256 = "0j3ca5qqvj294ax9xpxcm9s70vdkhk1sskn53hq3pcn3p9yr6phq";
  };
in

{

  home.packages = with pkgs; [
    lutris
  ];

  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
  };

  home.file.proton-ge-custom = rec {
    inherit source;
    recursive = true;
    target = ".steam/root/compatibilitytools.d/Proton-${version}/";
    onChange = "mkdir ${target}/files/share/default_pfx/dosdevices || true";
  };
}
