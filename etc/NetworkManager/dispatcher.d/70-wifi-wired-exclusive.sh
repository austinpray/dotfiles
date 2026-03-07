#!/bin/bash
export LC_ALL=C

enable_disable_wifi() {
    if nmcli dev | grep "ethernet" | grep -qw "connected"; then
        nmcli radio wifi off
    else
        nmcli radio wifi on
    fi
}

if [ "$2" = "up" ] || [ "$2" = "down" ]; then
    enable_disable_wifi
fi
