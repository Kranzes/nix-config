{ lib, stdenv, rofi, mpc_cli }:

stdenv.mkDerivation rec {
  pname = "rofi-mpd";
  version = "unstable-2021-09-15";

  src = ./.;

  dontBuild = true;
  dontConfigure = true;

  buildInputs = [ rofi mpc_cli ];

  installPhase = "install -D $src/${pname} $out/bin/${pname}";

  meta = with lib; {
    description = "A rofi menu for interacting with MPD written in Bash";
    platforms = platforms.unix;
  };
}
