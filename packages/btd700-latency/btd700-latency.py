import json
import os
import select
import subprocess
import sys
from pathlib import Path

REPORT_ID = 0x34
GET_MODE = 0x01
MODE_EVENT = 0x02
LATENCY_NS = {0: int(sys.argv[1]), 1: int(sys.argv[2])}


def find_hidraw():
    for dev in sorted(Path("/sys/class/hidraw").iterdir()):
        hid = dev / "device"
        uevent = (hid / "uevent").read_text()
        interface = hid.resolve().parent / "bInterfaceNumber"
        if "HID_ID=0003:00003542:00003001" in uevent and interface.read_text().strip() == "00":
            return Path("/dev") / dev.name
    sys.exit("BTD 700 control interface not found")


def find_sink():
    for obj in json.loads(subprocess.check_output(["pw-dump"])):
        props = (obj.get("info") or {}).get("props") or {}
        if str(props.get("node.name", "")).startswith("alsa_output.usb-Sennheiser_BTD_700"):
            return obj["id"]
    return None


def apply(mode):
    sink = find_sink()
    if sink is None:
        print("BTD 700 sink not found", flush=True)
        return False
    ns = LATENCY_NS[mode]
    subprocess.run(["pw-cli", "set-param", str(sink), "ProcessLatency", f"{{ ns = {ns} }}"], check=True, stdout=subprocess.DEVNULL)
    print(f"mode {mode}: latency {ns} ns on node {sink}", flush=True)
    return True


def main():
    fd = os.open(find_hidraw(), os.O_RDONLY)
    applied = None
    while True:
        select.select([fd], [], [])
        report = os.read(fd, 64)
        if len(report) < 5 or report[0] != REPORT_ID:
            continue
        kind, command = report[1], report[2]
        if (kind, command) not in ((0xFF, GET_MODE), (0xFC, MODE_EVENT)):
            continue
        mode = report[4]
        if mode in LATENCY_NS and mode != applied and apply(mode):
            applied = mode


main()
