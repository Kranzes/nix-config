{ writeShellApplication, rofi, mpc_cli }:

writeShellApplication {
  name = "rofi-mpd";
  runtimeInputs = [ rofi mpc_cli ];
  text = builtins.readFile ./rofi-mpd;
}
