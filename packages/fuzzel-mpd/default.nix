{
  writeShellApplication,
  fuzzel,
  mpc,
}:

writeShellApplication {
  name = "fuzzel-mpd";
  runtimeInputs = [
    fuzzel
    mpc
  ];
  text = builtins.readFile ./fuzzel-mpd;
}
