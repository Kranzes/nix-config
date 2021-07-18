#!/bin/sh

set -euE

# Event type for ThinkPad ACPI events.
EVENT_TYPE="ibm/hotkey"

# The event type codes from the thinkpad_acpi module:
# https://github.com/torvalds/linux/blob/v5.6/drivers/platform/x86/thinkpad_acpi.c#L173-L176
TP_HKEY_EV_HOTPLUG_DOCK=4010
TP_HKEY_EV_HOTPLUG_UNDOCK=4011


# is_event EVENT_CODE INPUT checks if some input represents this even code.
function is_event {
  # The event code is left-padded with 0s. Thus, a regular expression is used.
  local regexp
  regexp="^[0]*${1}$"

  [[ $2 =~ $regexp ]]
}


# log MESSAGE to the system log for debugging.
function log {
  @logger@ "[ThinkPad Dock ACPI-Event] $@"
}


log "called with $*"

# This script is called with one parameter, which is space separated. E.g.:
# > 'ibm/hotkey LEN0068:00 00000080 00004010'
# > 'ibm/hotkey LEN0068:00 00000080 00004011'
[[ $# -ne 1 ]] && \
  log "expected one parameter" && exit 1

args=($1)
[[ ${#args[@]} -ne 4 ]] && \
  log "argument is expected to have four fields" && exit 1

event_type="${args[0]}"
event_code="${args[3]}"

[[ "$EVENT_TYPE" != "$event_type" ]] && \
  log "invalid event type: $event_type instead of $EVENT_TYPE" && exit 1

@environment@

if is_event $TP_HKEY_EV_HOTPLUG_DOCK "$event_code"; then
  log "dock event"

  sleep 2
  @dockEvent@
elif is_event $TP_HKEY_EV_HOTPLUG_UNDOCK "$event_code"; then
  log "undock event"

  sleep 2
  @undockEvent@
else
  log "unsupported event code $event_code"
fi
