#!/bin/bash

# when detect HDMI-A-0(extesnion monitor), disable eDP (built-in monitor)
if [[ $(xrandr --listactivemonitors | grep 'HDMI-A-0') != "" ]]; then
  if [[ $(xrandr --listactivemonitors | grep 'eDP') != "" ]]; then
    xrandr --output eDP --off
  fi
fi
