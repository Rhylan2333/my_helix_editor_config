#!/usr/bin/env bash

/usr/bin/xrandr --output HDMI-A-0 --mode 2560x1440 --rate 99.95 &
/usr/bin/nmcli device wifi connect CAU &
/usr/bin/kmix &
/usr/bin/blueman-manager &
/home/caicai/Clash/cfw &
/home/caicai/Telegram/Telegram &
/opt/Stretchly/stretchly &
