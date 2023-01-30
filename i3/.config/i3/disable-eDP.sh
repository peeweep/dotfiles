#!/bin/bash

# when detect HDMI-A-0(extesnion monitor), disable eDP (built-in monitor)
if [[ $(xrandr --listactivemonitors | grep 'HDMI-A-0') != "" ]]; then
  if [[ $(xrandr --listactivemonitors | grep 'eDP') != "" ]]; then
    xrandr --output eDP --off
  fi
fi

# when detect 1920/.*x1080 (1080P monitor), disable it
if [[ $(xrandr --listactivemonitors | grep '1920.*1080') != "" ]]; then
  xrandr --output $(xrandr --listactivemonitors | grep '1920.*1080' | awk '{print $NF}') --off
fi
