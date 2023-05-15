#!/bin/bash

# HDMI primary dispaly on the left
# DP secondary dispaly on the right and rotate left
HDMI_DP() {
  local monitors=$(xrandr --query | grep ' connected' | awk '{print $1}')
  # must have 2 monitors
  if [[ $(echo "${monitors}" | wc -l) -ne 2 ]]; then
    return
  fi
  for monitor in ${monitors}; do
    # DP output name
    local CHECK_HDMI=$(echo "${monitor}" | grep HDMI)
    if [[ x"${CHECK_HDMI}" != x"" ]]; then
      local HDMI_monitor="${CHECK_HDMI}"
    fi
    # HDMI output name
    local CHECK_DP=$(echo "${monitor}" | grep DisplayPort)
    if [[ "${CHECK_DP}" != "" ]]; then
      local DP_monitor="${CHECK_DP}"
    fi
  done

  if [[ "${HDMI_monitor}" != "" && "${DP_monitor}" != "" ]]; then
    # init dp
    xrandr --output "${DP_monitor}" --auto
    # init hdmi
    xrandr --output "${HDMI_monitor}" --auto
    # hdmi left of dp
    xrandr --output "${HDMI_monitor}" --left-of "${DP_monitor}"
    # dp rotate left
    xrandr --output "${DP_monitor}" --rotate left
    # hdmi primary
    xrandr --output "${HDMI_monitor}" --primary
  fi
}

HDMI_DP
