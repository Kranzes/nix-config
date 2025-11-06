{
  writeShellApplication,
  rofi,
  mpc,
}:

writeShellApplication {
  name = "rofi-mpd";
  runtimeInputs = [
    rofi
    mpc
  ];
  text = builtins.readFile ./rofi-mpd;
}
