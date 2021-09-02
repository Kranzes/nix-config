{ config, pkgs, ... }:

let
  version = "6.15-GE-2";
  source = fetchTarball {
    url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/Proton-${version}.tar.gz";
    sha256 = "sha256-XJxBr4fXLRxMf+BZkqs27BfKsRoMS3Hk8kk10AanV7g=";
  };
in

{
  home.packages = with pkgs; [
    lutris
  ];

  home.file.proton-ge-custom = rec {
    inherit source;
    recursive = true;
    target = ".steam/root/compatibilitytools.d/Proton-${version}";
    onChange = "mkdir ${target}/files/share/default_pfx/dosdevices || true";
  };
}
