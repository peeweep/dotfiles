#!/bin/bash

# primary 4K dispaly on the left
# secondary 1080P dispaly on the right and rotate left
adjust_monitors() {
  all_monitors=$(xrandr --query | grep ' connected' | awk '{print $1}')
  # must have 2 monitors
  if [[ $(echo "${all_monitors}" | wc -l) -ne 2 ]]; then
    return
  fi
  monitor_4k=$(xrandr --query | grep ' connected' | grep 2160 | awk '{print $1}')
  monitor_1080p=$(xrandr --query | grep ' connected' | grep 1080 | awk '{print $1}')
  if [[ "${monitor_4k}" != "" && "${monitor_1080p}" != "" ]]; then
    # init 4k
    xrandr --output "${monitor_4k}" --auto
    # init 1080p
    xrandr --output "${monitor_1080p}" --auto
    # 4k on the left
    xrandr --output "${monitor_4k}" --left-of "${monitor_1080p}"
    # 1080p rotate left
    xrandr --output "${monitor_1080p}" --rotate left
    # 4k primary
    xrandr --output "${monitor_4k}" --primary
  fi

  i3 restart
}

adjust_monitors
