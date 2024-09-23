#!/bin/bash

# primary dispaly on the left
# secondary dispaly on the right and rotate left
adjust_monitors() {
  all_monitors=$(xrandr --query | grep ' connected' | awk '{print $1}')
  # must have 2 monitors
  if [[ $(echo "${all_monitors}" | wc -l) -ne 2 ]]; then
    return
  fi
  left_monitor=$(echo "${all_monitors}" | grep HDMI)
  right_monitor=$(echo "${all_monitors}" | grep DP)
  if [[ "${left_monitor}" != "" && "${right_monitor}" != "" ]]; then
    # init dp
    xrandr --output "${right_monitor}" --auto
    # init hdmi
    xrandr --output "${left_monitor}" --auto
    # hdmi left of dp
    xrandr --output "${right_monitor}" --left-of "${left_monitor}"
    # hdmi rotate left
    xrandr --output "${left_monitor}" --rotate left
    # dp primary
    xrandr --output "${right_monitor}" --primary
  fi

  i3 restart
}

adjust_monitors
