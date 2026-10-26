{ writers }:

writers.writePython3Bin "btd700-latency" {
  flakeIgnore = [ "E501" ];
} (builtins.readFile ./btd700-latency.py)
