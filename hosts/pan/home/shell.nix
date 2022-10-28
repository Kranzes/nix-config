{
  programs.zsh.shellAliases = {
    # fan speed
    fan-off = "echo level 0 | sudo tee /proc/acpi/ibm/fan";
    fan-low = "echo level 2 | sudo tee /proc/acpi/ibm/fan";
    fan-medium = "echo level 4 | sudo tee /proc/acpi/ibm/fan";
    fan-max = "echo level 7 | sudo tee /proc/acpi/ibm/fan";
    fan-auto = "echo level auto | sudo tee /proc/acpi/ibm/fan";

    # battery percentage/capacity
    bat-percent = "acpi";
    bat-capacity = "upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep --color=never capacity";
  };
}

